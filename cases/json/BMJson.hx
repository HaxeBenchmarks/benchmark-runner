import benchmark.Benchmark;

class BMJson {
	public static function main():Void {
		Benchmark.benchmarkAll(
			// version setup
			(haxe) -> {},
			// target compile
			(haxe, target) -> {
				classPaths: [".."],
				main: "BMJsonCode"
			},
			// target run
			(haxe, target) -> {
				timeout: 5 * 60
			}
		);
	}
}
