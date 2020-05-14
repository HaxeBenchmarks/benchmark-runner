import benchmark.Benchmark;

class BMNBody {
	public static function main():Void {
		Benchmark.benchmarkAll( // version setup
			(haxe) -> {}, // target compile
			(haxe, target) -> {
				classPaths: [".."],
				main: "BMNBodyCode",
				useLibraries: []
			}, // target run
			(haxe, target) -> {
				timeout: 3 * 60
			});
	}
}
