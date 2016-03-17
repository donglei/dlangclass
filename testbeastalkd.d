import kerisy.utils.beastalkd;
import std.stdio;
void main()
{
	auto tubename ="sms";
	 auto server = new Server("10.1.11.31", 11300);
    auto tube = server.getTube(tubename);
    tube.watch(tubename);

    Job job;

    while(job = tube.reserve(), job !is null){
		writeln(job.id, "------", cast(string)job.data);
		auto stats = job.stats();
		writeln(stats);
	}
	

}