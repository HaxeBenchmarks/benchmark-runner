import sys.FileSystem;
import benchmark.Benchmark;

class BMFormatter {
	public static function main():Void {
		var dataSources = [
			{dir: "haxe", url: "https://github.com/HaxeFoundation/haxe.git", sub: "std"},
			{dir: "openfl", url: "https://github.com/openfl/openfl.git", sub: "src"},
			{dir: "lime", url: "https://github.com/openfl/lime.git", sub: "src"}
		];
		FileSystem.createDirectory("data");
		var args = [];
		for (source in dataSources) {
			args.push("-s");
			args.push('../data/${source.dir}/${source.sub}');
			// don't check out fresh sources automatically
			// should be a manual, because new sources will have an effect on benchmark runtime
			#if POPULATE_DATA
			if (!FileSystem.exists('data/${source.dir}'))
				Sys.command('git clone ${source.url} --depth 1 data/${source.dir}');
			#end
		}
		Benchmark.benchmarkAll( // version setup
			(haxe) -> {
				installLibraries: haxe == "haxe3" ? [
					"formatter" => "haxelib:/formatter#1.9.1",
					"haxeparser" => "gh://github.com/Simn/haxeparser#48160b190cacafb0003d0c8d085dca2c85e21e31",
					"hxargs" => "haxelib:/hxargs#3.0.2",
					"hxjsonast" => "haxelib:/hxjsonast#1.0.1",
					"hxparse" => "gh://github.com/Simn/hxparse#f61faa2021f2abb85360f997ff72c4156c891adc",
					"json2object" => "haxelib:/json2object#3.6.4",
					"tokentree" => "haxelib:/tokentree#1.0.23"
				] : [
					"formatter" => "haxelib:/formatter#1.9.1",
					"haxeparser" => "gh://github.com/Simn/haxeparser#e5746bfc55c09a3694db42738ff575b91441971a",
					"hx3compat" => "haxelib:/hx3compat#1.0.3",
					"hxargs" => "gh://github.com/simn/hxargs#1d8ec84f641833edd6f0cb2e4290b7524fd27219",
					"hxjsonast" => "haxelib:/hxjsonast#1.0.1",
					"hxparse" => "gh://github.com/Simn/hxparse#864064538084d75611785bd561c8517e56f2ebc4",
					"json2object" => "gh://github.com/elnabo/json2object#a75859de1e966c09e73591b6c9186086c143fe60",
					"tokentree" => "haxelib:/tokentree#1.0.23"
				]
			}, // target compile
			(haxe, target) -> {
				useLibraries: ["tokentree", "haxeparser", "hxparse", "json2object", "hxargs", "formatter"],
				classPaths: [".."],
				main: "BMFormatterCode"
			}, // target run
			(haxe, target) -> {
				var cwd = Sys.getCwd();
				for (source in dataSources) {
					Sys.setCwd('../data/${source.dir}');
					Sys.command('git checkout -- .');
					Sys.setCwd(cwd);
				}
				{
					args: args,
					timeout: 5 * 60
				};
			});
	}
}
