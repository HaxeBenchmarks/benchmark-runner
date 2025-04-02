import haxe.Json;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.io.Path;
import sys.FileSystem;
import sys.FileSystem;
import sys.io.File;
import formatter.Cli;
import formatter.FormatStats;
import formatter.Formatter.Result;
import formatter.Formatter;
import formatter.config.Config;
import formatter.config.FormatterConfig;
import json2object.JsonParser;

class BMFormatterCode {
	var verbose:Bool = false;
	var mode:Mode = Format;
	var exitCode:Int = 0;
	var lastConfigFileName:Null<String>;

	static function main() {
		try {
			new BMFormatterCode();
		} catch (e:Any) {
			#if python
			if ('$e' == "SystemExit(0)") {
				// Python throws a SystemExit exception when calling sys.exit(x)
				// so in case the run was fine we need to make sure CI doesn't think it failed
				Sys.exit(0);
			}
			#end
			trace(e);
			Sys.exit(1);
		}
	}

	function new() {
		var args = Sys.args();

		#if cppia
		args.shift();
		#else
		if (Sys.getEnv("HAXELIB_RUN") == "1") {
			if (args.length > 0) {
				Sys.setCwd(args.pop());
			}
		}
		#end

		var paths = [];
		var help = false;
		var pipemode = false;
		var argHandler = hxargs.Args.generate([
			@doc("File or directory with .hx files to format (multiple allowed)")
			["-s", "--source"] => function(path:String) paths.push(path),

			@doc("Print additional information")
			["-v"] => function() verbose = true,

			@doc("Don't format, only check if files are formatted correctly")
			["--check"] => function() mode = Check,

			#if debug
			@doc("Don't format, only check if formatting is stable")
			["--check-stability"] => function() mode = CheckStability,
			#end

			@doc("Display this list of options")
			["--help"] => function() help = true
		]);

		function printHelp() {
			var version:String = FormatterVersion.getFormatterVersion();
			Sys.println('Haxe Formatter ${version}');
			Sys.println(argHandler.getDoc());
		}

		try {
			argHandler.parse(args);
		} catch (e:Any) {
			Sys.stderr().writeString(e + "\n");
			printHelp();
			Sys.exit(1);
		}
		if (args.length == 0 || help) {
			printHelp();
			Sys.exit(0);
		}

		run(paths);
		Sys.exit(exitCode);
	}

	function run(paths:Array<String>) {
		for (path in paths) {
			var path:String = StringTools.trim(path);
			if (!FileSystem.exists(path)) {
				Sys.println('Skipping \'$path\' (path does not exist)');
				continue;
			}
			if (FileSystem.isDirectory(path)) {
				run([for (file in FileSystem.readDirectory(path)) Path.join([path, file])]);
			} else {
				formatFile(path);
			}
		}
	}

	function formatFile(path:String) {
		if (path.endsWith(".hx")) {
			var config = Formatter.loadConfig(path);
			if (verbose) {
				verboseLogFile(path, config);
			}
			var content:String = File.getContent(path);
			var result:Result = Formatter.format(Code(content), config);
			switch (result) {
				case Success(formattedCode):
					FormatStats.incSuccess();
					switch (mode) {
						case Format:
							File.saveContent(path, formattedCode);
						case Check:
							if (formattedCode != content.toString()) {
								Sys.println('Incorrect formatting in $path');
								exitCode = 1;
							}
						case CheckStability:
							var secondResult = Formatter.format(Code(formattedCode), config);
							function unstable() {
								Sys.println('Unstable formatting in $path');
								exitCode = 1;
							}
							switch (secondResult) {
								case Success(formattedCode2) if (formattedCode != formattedCode2):
									unstable();
								case Failure(errorMessage):
									unstable();
								case _:
							}
					}
				case Failure(errorMessage):
					FormatStats.incFailed();
					Sys.stderr().writeString('Failed to format $path: $errorMessage\n');
					exitCode = 1;
				case Disabled:
					FormatStats.incDisabled();
			}
		}
	}

	function verboseLogFile(path:String, config:Null<Config>) {
		if (config != null) {
			if ((lastConfigFileName == null) || (lastConfigFileName != config.configFileName)) {
				if (lastConfigFileName != null) {
					Sys.println("");
				}
				lastConfigFileName = config.configFileName;
				Sys.println('Using $lastConfigFileName:');
			}
		}
		var action = if (mode == Format) "Formatting" else "Checking";
		Sys.println('$action $path');
	}

	#if nodejs
	function readNodeJsBytes(stdIn:haxe.io.Input):Bytes {
		var bufsize:Int = 1 << 14;
		var buf = Bytes.alloc(bufsize);
		var total = new haxe.io.BytesBuffer();
		try {
			while (true) {
				var len = stdIn.readBytes(buf, 0, bufsize);
				if (len == 0) {
					break;
				}
				total.addBytes(buf, 0, len);
			}
		} catch (e:Any) {}
		return total.getBytes();
	}
	#end
}
