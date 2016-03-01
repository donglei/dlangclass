import std.stdio;
void main()
{
	auto no = TransactionGenerater.generate("T");
	std.stdio.writeln(no);
}

///生成订单号程序
class TransactionGenerater{
	import std.datetime;
	import std.string;
	import std.format;
	import std.random;
	///生成订单 prefix +时间 + 机器编号 
	public static string generate(string prefix = "")
	{
		auto currentTime = Clock.currTime();
		auto machineCode = uniform(10, 100);
		return format("%s%s%s", prefix, currentTime.toISOString().removechars("T.").leftJustify(21, '0'), machineCode);
	}
	
}
