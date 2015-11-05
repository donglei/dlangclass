module kerisy.utils.websockets;
import std.bitmanip;

enum FrameOpcode {
	CONTINUATION = 0x0,
	TEXT = 0x1,
	BINARY = 0x2,
	CLOSE = 0x8,
	PING = 0x9,
	PONG = 0xA
}

///web socket data package
struct WebSocketsDataPackage{

	bool fin;
	bool masked = false;
	FrameOpcode opcode;
	ulong length;
	ubyte[4] maskingKey;
	ubyte[] payload;

	static WebSocketsDataPackage* readFrame(ubyte[] stream)
	{
		WebSocketsDataPackage *dataPackage = new WebSocketsDataPackage;
		dataPackage.fin = (stream[0] & 0x80) == 0x80;
		dataPackage.opcode =  cast(FrameOpcode)(stream[0] & 0xf);
		dataPackage.masked =  (stream[1] & 0x80) == 0x80;
		//parsing length
		ulong length = stream[1] & 0x7f;
		ushort start = 2;
		if( length == 126 ) {
			//2字节长度
			length = bigEndianToNative!ushort(stream[2 ..4]);
			start = 4;
		} else if( length == 127 ) {
			// 8字节长度
			length = bigEndianToNative!ulong(stream[2 ..10]);
			start = 10;
		}
		dataPackage.length = length;
		if(dataPackage.masked)
		{
			//4位掩码长度
			dataPackage.maskingKey = stream[start .. start+4];
			start += 4;
		}
		dataPackage.payload = stream[start .. $];
		//解码
		if(dataPackage.masked)
		{
			for( size_t i = 0; i < length; ++i ) {
				dataPackage.payload[i] = dataPackage.payload[i] ^ dataPackage.maskingKey[i % 4];
			}
		}
		return dataPackage;
	}

	ubyte[] send()
	{
		import std.array, std.range;
		ubyte[] toSendByte;
		ubyte firstByte = cast(ubyte)opcode;
		if (fin) firstByte |= 0x80;
		toSendByte ~= firstByte;
		if( payload.length < 126 ) {
			toSendByte ~= std.bitmanip.nativeToBigEndian(cast(ubyte)payload.length);
		} else if( payload.length <= 65536 ) {
			toSendByte ~= cast(ubyte[])[126];
			toSendByte ~= std.bitmanip.nativeToBigEndian(cast(ushort)payload.length);
		} else {
			toSendByte ~= cast(ubyte[])[127];
			toSendByte ~= std.bitmanip.nativeToBigEndian(payload.length);
		}
		toSendByte ~= payload;
		return toSendByte;
	}
}

unittest{
	ubyte[] toDeal = [129, 169, 7, 29, 233, 165, 78, 61, 136, 200, 39, 105, 129, 192, 39, 126, 133, 204, 98, 115, 157, 133, 102, 115, 141, 133, 78, 58, 132, 133, 107, 116, 154, 209, 98, 115, 128, 203, 96, 60, 201, 77, 150, 190, 14, 6, 141];
	WebSocketsDataPackage dataPackage = WebSocketsDataPackage.readFrame(toDeal);
	std.stdio.writeln(dataPackage);

	WebSocketsDataPackage sendPackage;
	sendPackage.fin = true;
	sendPackage.opcode = FrameOpcode.TEXT;
	sendPackage.payload = cast(ubyte[])"Hello world";

	auto _tosend = sendPackage.send();

}
