import benchmark.Benchmark;

class BMMandelbrotAnonObjects {
	public static function main():Void {
		Benchmark.benchmarkAll(
			// version setup
			(haxe) -> {},
			// target compile
			(haxe, target) -> {
				classPaths: ["..", "../../mandelbrot"],
				defines: ["anon_objects" => ""],
				main: "BMMandelbrotCode"
			},
			// target run
			(haxe, target) -> {
				timeout: 60
			}
		);
	}
}
