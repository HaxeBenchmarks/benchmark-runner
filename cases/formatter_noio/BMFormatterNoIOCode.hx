import haxe.Timer;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import formatter.Formatter;
import formatter.config.Config;
import tokentree.TokenTreeBuilder.TokenTreeEntryPoint;

class BMFormatterNoIOCode {
	public function new() { 
		// segmentation faults in C++
		// var sources:Array<String> = BenchmarkStatMacro.getSources("dataNoIO");

		var sources:Array<String> = getSources("../data");
		var config:Config = new Config();
		var config2:Config = new Config();
		config2.lineEnds.leftCurly = Both;

		for (i in 0...30) {
			for (src in sources) {
				Formatter.format(Code(src), config, null, TokenTreeEntryPoint.TYPE_LEVEL);
				Formatter.format(Code(src), config2, null, TokenTreeEntryPoint.TYPE_LEVEL);
			}
		}
	}

	function getSources(path:String):Array<String> {
		var sources:Array<String> = [];

		var folderFunc:String->Void = null;
		folderFunc = function(path:String):Void {
			for (f in FileSystem.readDirectory(path)) {
				var fileName:String = Path.join([path, f]);
				if (FileSystem.isDirectory(fileName)) {
					folderFunc(fileName);
					continue;
				}
				sources.push(File.getContent(fileName));
			}
		}
		folderFunc(path);
		return sources;
	}

	static function main() {
		try {
			new BMFormatterNoIOCode();
		} catch (e:Any) {
			trace(e);
		}
	}
}
