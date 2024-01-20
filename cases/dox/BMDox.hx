import sys.FileSystem;
import sys.io.File;
import benchmark.Benchmark;

class BMDox {
	public static function main():Void {
		Sys.command("git clone https://github.com/HaxeFoundation/dox.git --depth 1 dox");

		#if POPULATE_DATA
		Sys.command("svn export https://github.com/HaxeFoundation/api.haxe.org/trunk/xml/4.1.0");
		#end

		var metaJson:String = File.getContent("dox/resources/meta.json");
		FileSystem.createDirectory("benchmark-run/resources");
		File.saveContent("benchmark-run/resources/meta.json", metaJson);
		Benchmark.benchmarkAll( // version setup
			(haxe) -> {
				if (haxe == "haxe3") {
					// doesn't run on Haxe 3
					return Benchmark.SKIP;
				}
				{
					installLibraries: [
						// "hx3compat" => "haxelib:/hx3compat#1.0.3",
						"hxargs" => "gh://github.com/simn/hxargs#1d8ec84f641833edd6f0cb2e4290b7524fd27219",
						"hxparse" => "gh://github.com/Simn/hxparse#876070ec62a4869de60081f87763e23457a3bda8",
						"hxtemplo" => "gh://github.com/Simn/hxtemplo#760a81368d1a877e9fd43fc7bf0d1de83e654f3e",
						"markdown" => "haxelib:markdown"
					]
				}
			}, // target compile
			(haxe, target) -> {
				{
					useLibraries: ["hxtemplo", "hxparse", "hxargs", "markdown"],
					classPaths: ["..", "../dox/src"],
					compileArgs: ["-dce" => "no"],
					main: "BMDoxCode"
				}
			}, // target run
			(haxe, target) -> {
				Sys.command("rm -rf pages");
				{
					args: ["-theme", "../dox/themes/default", "-i", "../data"],
					timeout: 3 * 60
				}
			});
	}
}
