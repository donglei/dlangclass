module ithox.helper;

public import core.stdc.time;

///Unix 时间戳自1970年的秒数
time_t getCurrentUnixTime()
{
	return core.stdc.time.time(null);
}
/// return format 201507
string getYearMonthFormat()
{
	import std.datetime;
	import std.format;
	auto currentTime = Clock.currTime();
	return format("%d%02d", currentTime.year, currentTime.month);
}
