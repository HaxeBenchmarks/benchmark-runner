package benchmark.data;

typedef ArchivedResults = Array<TestRun>;

typedef TestRun = {
	var haxeVersion:String;
	@:optional var toolVersions:Map<Tool, String>;
	var date:String;
	var targets:Array<TargetResult>;
}

typedef TargetResult = {
	var name:String;
	var time:Float;
	var compileTime:Null<Float>;
	@:optional var status:ResultStatus;
}

enum DatasetType {
	Haxe3;
	Haxe4;
	HaxeNightly;
	HaxePR;
}

enum abstract Tool(String) {
	var Hxcpp = "hxccp";
	var Php = "php";
	var Mono = "mono";
	var Python = "python";
	var Lua = "lua";
	var LuaJit = "luajit";
	var Hl = "hl";
	var NodeJs = "nodejs";
	var Java = "java";
	var HxNodeJs = "hxnodejs";
	var HxCs = "hxcs";
	var HxJava = "hxjava";
	var HaxePR = "HaxePR";
}

abstract TimeValue(Float) to Float {
	function new(value:Float) {
		this = value;
	}

	@:from
	public static function fromFloat(value:Null<Float>):Null<TimeValue> {
		if (value == null) {
			return null;
		}
		return new TimeValue(Math.round(value * 1000) / 1000);
	}
}

enum abstract ResultStatus(Int) {
	var Success = 0;
	var CompileFailed = 1;
	var RunFailed = 2;
	var VerifyFailed = 3;
}

typedef ArchivedResultsV1 = Array<TestRunV1>;

typedef TestRunV1 = {
	var haxeVersion:String;
	var date:String;
	var targets:Array<TargetResultV1>;
}

typedef TargetResultV1 = {
	var name:String;
	var inputLines:Int;
	var outputLines:Int;
	var time:Float;
}
