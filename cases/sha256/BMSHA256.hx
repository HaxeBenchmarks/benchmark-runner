import benchmark.Benchmark;

class BMSHA256 {
	public static function main():Void {
		Benchmark.benchmarkAll(
			// version setup
			(haxe) -> {},
			// target compile
			(haxe, target) -> {
				classPaths: [".."],
				main: "BMSHA256Code"
			},
			// target run
			(haxe, target) -> {
				timeout: 4 * 60
			}
		);
	}
}
