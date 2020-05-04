# Haxe Alloc Benchmark

* benchmark server is an Intel(R) Xeon(R) CPU E3-1270 v6 @ 3.80GHz
* benchmark runs use lix and run on Haxe 3.4.7, Haxe 4.0.5 and Haxe 4 nightly
* a cron job triggers builds multiple times a day
* each build job compiles Haxe formatter to C++, Cppia, C#, Hashlink, Hashlink/C, Java, JVM, eval, Neko, NodeJS, PHP, Python and Lua targets
* JVM and eval are not available on Haxe 3 (Haxe 4 only)
* Haxe 3 uses Hashlink 1.1, Haxe 4 Hashlink 1.11
* NodeJS compilation is run twice, with and without "-D js-es=6" (Haxe 4 builds only)
* C++ compilation is run twice, with and without "-D HXCPP_GC_GENERATIONAL"

* testcase code:

```haxe
var count:Int = 500000;

allocBytes(count, 100);
allocBytes(count, 1000);
allocBytes(count, 101);
allocBytes(count, 1001);
allocBytes(count, 102);

function allocBytes(count:Int, size:Int) {
    var data:Array<Bytes> = [];
    for (i in 0...count) {
        var bytes:Bytes = Bytes.alloc(size);
        bytes.fill(0, size, i);
        data.push(bytes);
    }
    for (i in 0...count) {
        var bytes:Bytes = Bytes.alloc(size);
        bytes.fill(0, size, i);
        bytes.compare(data[i]);
    }
}
```

* results update after every build (page doesn't automatically reload)
* sources available here: [HaxeBenchmarks/benchmark-runner](https://github.com/HaxeBenchmarks/benchmark-runner)
