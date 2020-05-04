import benchmark.Benchmark;

class BMAlloc {
	public static function main():Void {
		Benchmark.benchmarkAll(
			// version setup
			(haxe) -> {},
			// target compile
			(haxe, target) -> {
				classPaths: [".."],
				main: "BMAllocCode"
			},
			// target run
			(haxe, target) -> {
				timeout: 6 * 60
			}
		);
	}
}
