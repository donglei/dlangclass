/**
* @author donglei
*/

import std.algorithm, std.typecons;

///实现php中的ksort 功能
 Tuple!(K, V)[] aa_sort(K, V)(V[K] aa){
     typeof(return) r=[];
     foreach(k,v;aa) r~=tuple(k,v);
     sort!q{a[0]<b[0]}(r);
     return r;
 }
 
 /// 实现普通sign 签名功能
 string aa_sorted_sign(string[string] data, string sign_key = string.init)
 {
	import std.stdio, std.uri;
	auto sortbb= aa_sort(data);
	string[] need_md5;
	writeln(sortbb);
	foreach( cc ; sortbb)
	{
		if(cc[0] == "sign")
		{
			continue;
		}
		need_md5 ~= cc[0] ~ "=" ~ encodeComponent(cc[1]);
	}
	import std.digest.md, std.digest.sha, std.array;
    import std.string: toLower;
	return toHexString(md5Of(need_md5.join('&') ~ sign_key)).toLower();
 }
 

 void main()
 {
	auto bb = [
		"name":"donglei",
		"id":"8888",
		"age":"123",
		"age1":"123"
	];
	import std.stdio;
	writeln(aa_sorted_sign(bb, "123"));
	writeln(aa_sorted_sign(bb));
	
 }