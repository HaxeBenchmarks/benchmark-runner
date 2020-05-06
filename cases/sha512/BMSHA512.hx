import benchmark.Benchmark;

class BMSHA512 {
	public static function main():Void {
		Benchmark.benchmarkAll(
			// version setup
			(haxe) -> {
				installLibraries: [
					"crypto" => "gh://github.com/HaxeFoundation/crypto"
				]
			},
			// target compile
			(haxe, target) -> {
				classPaths: [".."],
				main: "BMSHA512Code",
				useLibraries: [
					"crypto"
				]
			},
			// target run
			(haxe, target) -> {
				timeout: 2 * 60
			}
		);
	}
}
