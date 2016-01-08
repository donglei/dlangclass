```
void testbeanstalk()
{
	import stalkd;
	writeln(123);
	auto server = new Server("127.0.0.1", 11300);
	writeln(33);
	auto tube = server.getTube("image-server");
	auto job  = new Job();

	job.append("This is a test job.image-server");
	tube.put(job);
	tube.put(job);
	tube.put(job);
	

	tube.watch("image-server");
	Job j;
	while(j = tube.reserve(2), j !is null){
		writeln(j.id, "---", cast(string)j.data);
		j.destroy();
	}


	tube.watch("image-server");
	while(j = tube.reserve(2), j !is null){
		writeln(j.id, "-++-", cast(string)j.data);
		j.destroy();
	}
}
```
