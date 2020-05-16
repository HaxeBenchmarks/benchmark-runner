import benchmark.Benchmark;

class BMBinaryTrees {
	public static function main():Void {
		Benchmark.benchmarkAll( // version setup
			(haxe) -> {}, // target compile
			(haxe, target) -> {
				classPaths: [".."],
				main: "BMBinaryTreesCode",
				useLibraries: []
			}, // target run
			(haxe, target) -> {
				timeout: 3 * 60
			});
	}
}
