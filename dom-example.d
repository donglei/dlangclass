import std.stdio;

void main()
{
	import arsd.dom;
	string xml = `<xml><return_code><![CDATA[SUCCESS]]></return_code>
<return_msg><![CDATA[OK]]></return_msg>
<appid><![CDATA[wx06a0e77b790bbc19]]></appid>
<mch_id><![CDATA[1308474501]]></mch_id>
<nonce_str><![CDATA[v0FK8hrQJ4NqMLoT]]></nonce_str>
<sign><![CDATA[FC4016C251CEE84D4DF0C90457242AE3]]></sign>
<result_code><![CDATA[SUCCESS]]></result_code>
<prepay_id><![CDATA[wx20170413110145ae31d512e40733401154]]></prepay_id>
<trade_type><![CDATA[APP]]></trade_type>
</xml>`;

	import std.string;
	xml = xml.replace("\n", "");
	XmlDocument docs = new XmlDocument(xml);
	auto code = docs.querySelector("return_code");
	writeln(code.directText);
	writeln("ddd",docs.querySelector("xml"));

	Element rootE = docs.querySelector("xml");
	Element node = rootE.firstChild();
	string[string] hashMap;
	while (node !is null)
	{
		writeln("Tag Name:", node.tagName, " value:", node.directText);
		hashMap[node.tagName] = node.directText;
		node = node.nextSibling();
	}
	writeln(hashMap);
}
