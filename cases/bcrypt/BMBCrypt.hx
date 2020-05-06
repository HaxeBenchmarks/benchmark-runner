import benchmark.Benchmark;

class BMBCrypt {
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
				main: "BMBCryptCode",
				useLibraries: [
					"crypto"
				]
			},
			// target run
			(haxe, target) -> {
				timeout: 3 * 60
			}
		);
	}
}
