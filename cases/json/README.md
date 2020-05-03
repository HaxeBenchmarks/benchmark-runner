# Haxe Json Benchmark

* benchmark server is an Intel(R) Xeon(R) CPU E3-1270 v6 @ 3.80GHz
* benchmark runs use lix and run on Haxe 3.4.7, Haxe 4.0.5 and Haxe 4 nightly
* a cron job triggers builds multiple times a day
* each build job compiles Haxe formatter to C++, Cppia, C#, Hashlink, Hashlink/C, Java, JVM, eval, Neko, NodeJS, PHP, Python and Lua targets
* JVM and eval are not available on Haxe 3 (Haxe 4 only)
* Haxe 3 uses Hashlink 1.1, Haxe 4 Hashlink 1.11
* NodeJS compilation is run twice, with and without "-D js-es=6" (Haxe 4 builds only)
* C++ compilation is run twice, with and without "-D HXCPP_GC_GENERATIONAL"

* testcase reads hxformat-schema.json and Json.parse and Json.stringifys it 500 times, it also places 500 copies inside an array stringify and parses it once

* results update after every build (page doesn't automatically reload)
* sources available here: [HaxeBenchmarks/benchmark-runner](https://github.com/HaxeBenchmarks/benchmark-runner)
