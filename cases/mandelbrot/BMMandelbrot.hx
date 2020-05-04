import benchmark.Benchmark;

class BMMandelbrot {
	public static function main():Void {
		Benchmark.benchmarkAll(
			// version setup
			(haxe) -> {},
			// target compile
			(haxe, target) -> {
				classPaths: [".."],
				main: "BMMandelbrotCode"
			},
			// target run
			(haxe, target) -> {
				timeout: 60
			}
		);
	}
}
