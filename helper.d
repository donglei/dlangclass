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

/// converts camel case MyEntityName to my_entity_name
string camelCaseToUnderscoreDelimited(immutable string s) {
    string res;
    bool lastLower = false;
    foreach(ch; s) {
        if (ch >= 'A' && ch <= 'Z') {
            if (lastLower) {
                lastLower = false;
                res ~= "_";
            }
            res ~= std.ascii.toLower(ch);
        } else if (ch >= 'a' && ch <= 'z') {
            lastLower = true;
            res ~= ch;
        } else {
            res ~= ch;
        }
    }
    return res;
}
