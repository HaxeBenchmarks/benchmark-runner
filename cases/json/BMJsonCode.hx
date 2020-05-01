import haxe.Json;
import sys.FileSystem;
import sys.io.File;

class BMJsonCode {
	static inline var REPEATS = 500;

	public static function main():Void {
		var text = File.getContent("../data/hxformat-schema.json");
		var schema:Any = Json.parse(text);
		var listOfSchema:Array<Any> = [ for (i in 0...REPEATS) schema ];
		for (i in 0...REPEATS) {
			text = Json.stringify(schema);
			schema = Json.parse(text);
		}
		text = Json.stringify(listOfSchema);
		schema = Json.parse(text);
	}
}
