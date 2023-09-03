package benchmark;

import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import benchmark.data.TestRun;

using StringTools;

class Benchmark {
	public static final TARGET_FILTER:Array<String> = {
		var env = Sys.getEnv("BENCHMARK_TARGETS");
		env != null ? env.split(",") : null;
	};
	public static final VERSION_FILTER:Array<String> = {
		var env = Sys.getEnv("BENCHMARK_VERSIONS");
		env != null ? env.split(",") : null;
	};
	public static final SKIP:CompileParams = {};

	public static final KEEP_BINARY:Bool = {
		var env = Sys.getEnv("BENCHMARK_KEEP_BINARY");
		env != null ? env == "keep" : false;
	};

	public static final HAS_TIMEOUT:Bool = scmd('../../scripts/tools/detect-timeout.sh') == 0;
	static var detectedTools:Map<Tool, String> = detectToolVersions();

	// base relative to cases/*/benchmark-run
	static final BENCHMARK_BASE = "../../..";
	static final SCRIPTS_BASE = '$BENCHMARK_BASE/scripts';

	static function createTargets():Array<Target>
		return [
			// cpp
			{
				name: "C++",
				id: "cpp",
				compile: "-cpp out/cpp",
				run: "out/cpp/Main",
			},
			{
				name: "C++ (GC Gen)",
				id: "cppGCGen",
				compile: "-cpp out/cppGCGen",
				run: "out/cppGCGen/Main",
				defines: ["HXCPP_GC_GENERATIONAL" => ""]
			},
			{
				name: "Cppia",
				id: "cppia",
				compile: "-cppia out/cppia.cppia",
				run: "haxelib run hxcpp out/cppia.cppia"
			},
			// cs
			{
				name: "C#",
				id: "cs",
				compile: "-cs out/cs",
				run: "mono out/cs/bin/Main.exe"
			},
			// eval
			{
				name: "Eval",
				id: "eval",
				compile: "" // eval is handled separately
			},
			// hl
			{
				name: "HashLink",
				id: "hl",
				compile: "-hl out/hl.hl",
				run: '$SCRIPTS_BASE/hl-1.13/run-hl.sh out/hl.hl',
				installLibraries: ["hashlink" => "haxelib:/hashlink#0.1.0"]
			},
			{
				name: "HashLink/C",
				id: "hlc",
				compile: "-hl out/hlc/hlc.c",
				postCompile: '$SCRIPTS_BASE/hl-1.13/compile.sh out/hlc',
				run: '$SCRIPTS_BASE/hl-1.13/run-hlc.sh out/hlc/hlc',
				installLibraries: ["hashlink" => "haxelib:/hashlink#0.1.0"]
			},
			{
				name: "HashLink Immix",
				id: "hlGCImmix",
				compile: "-hl out/hl.hl",
				run: '$SCRIPTS_BASE/hl-immix/run-hl.sh out/hl.hl',
				installLibraries: ["hashlink" => "haxelib:/hashlink#0.1.0"]
			},
			{
				name: "HashLink/C Immix",
				id: "hlcGCImmix",
				compile: "-hl out/hlc/hlc.c",
				postCompile: '$SCRIPTS_BASE/hl-immix/compile.sh out/hlc',
				run: '$SCRIPTS_BASE/hl-immix/run-hlc.sh out/hlc/hlc',
				installLibraries: ["hashlink" => "haxelib:/hashlink#0.1.0"]
			},
			// java
			{
				name: "Java",
				id: "java",
				compile: "-java out/java",
				run: "java -jar out/java/Main.jar"
			},
			{
				name: "JVM",
				id: "jvm",
				compile: "-java out/jvm",
				defines: ["jvm" => ""],
				run: "java -jar out/jvm/Main.jar"
			},
			// js
			{
				name: "NodeJS",
				id: "js",
				compile: "-js out/js.js",
				installLibraries: ["hxnodejs" => "gh://github.com/HaxeFoundation/hxnodejs"],
				useLibraries: ["hxnodejs"],
				run: "node out/js.js"
			},
			{
				name: "NodeJS (ES6)",
				id: "js-es6",
				compile: "-js out/js-es6.js",
				installLibraries: ["hxnodejs" => "gh://github.com/HaxeFoundation/hxnodejs"],
				useLibraries: ["hxnodejs"],
				defines: ["js-es" => "6"],
				run: "node out/js-es6.js"
			},
			// lua
			{
				name: "Lua",
				id: "lua",
				compile: "-lua out/lua.lua",
				run: "lua out/lua.lua"
			},
			// luajit
			{
				name: "Luajit",
				id: "luajit",
				compile: "-lua out/luajit.lua",
				run: "luajit out/luajit.lua"
			},
			// neko
			{
				name: "Neko",
				id: "neko",
				compile: "-neko out/neko.n",
				run: "neko out/neko.n"
			},
			// php
			{
				name: "PHP",
				id: "php",
				compile: "-php out/php",
				defines: ["php7" => ""],
				run: "php out/php/index.php"
			},
			// python
			{
				name: "Python",
				id: "python",
				compile: "-python out/python.py",
				run: "python3 out/python.py"
			}
		];

	public static var VERSIONS:Array<Version> = {
		#if with_haxe3
		var haxe3targets:Array<Target> = [
			for (target in createTargets()) {
				switch (target.id) {
					case "cppGCGen" | "jvm" | "hl" | "hlc" | "hlGCImmix" | "hlcGCImmix":
						continue;
					case "cs":
						target.installLibraries = ["hxcs" => "haxelib:/hxcs#3.4.0"];
					case "java":
						target.installLibraries = ["hxjava" => "haxelib:/hxjava#3.2.0"];
					case "cppia" | "cpp":
						target.init = '$SCRIPTS_BASE/hxcpp/setup-haxe3.sh';
					case _:
				}
				target;
			}
		].concat([
			{
				name: "HashLink",
				id: "hl",
				compile: "-hl out/hl.hl",
				run: '$SCRIPTS_BASE/hl-1.1/run-hl.sh out/hl.hl',
				installLibraries: ["hashlink" => "haxelib:/hashlink#0.1.0"]
			},
			{
				name: "HashLink/C",
				id: "hlc",
				compile: "-hl out/hlc/hlc.c",
				postCompile: '$SCRIPTS_BASE/hl-1.1/compile.sh out/hlc',
				run: '$SCRIPTS_BASE/hl-1.1/run-hlc.sh out/hlc/hlc',
				installLibraries: ["hashlink" => "haxelib:/hashlink#0.1.0"]
			}
		]);
		#end
		var haxe4targets:Array<Target> = [
			for (target in createTargets()) {
				switch (target.id) {
					case "cs":
						target.installLibraries = ["hxcs" => "haxelib:/hxcs#4.0.0-alpha"];
					case "java" | "jvm":
						target.installLibraries = ["hxjava" => "haxelib:/hxjava#4.0.0-alpha"];
					case "cppia" | "cpp" | "cppGCGen":
						target.init = '$SCRIPTS_BASE/hxcpp/setup-haxe4.sh';
					case _:
				}
				target;
			}
		];
		var haxeNightlytargets:Array<Target> = [
			for (target in createTargets()) {
				switch (target.id) {
					case "cs":
						target.installLibraries = ["hxcs" => "haxelib:/hxcs#4.0.0-alpha"];
					case "java" | "jvm":
						target.installLibraries = ["hxjava" => "haxelib:/hxjava#4.0.0-alpha"];
					case "cppia" | "cpp" | "cppGCGen":
						target.init = '$SCRIPTS_BASE/hxcpp/setup-haxeNightly.sh';
					case _:
				}
				target;
			}
		];
		var vers:Array<Version> = [
			#if use_haxe_path
			{
				name: "Haxe (PATH)",
				id: "haxe-path",
				lixId: null,
				env: [],
				jsonOutput: "haxe-path.json",
				targets: haxeNightlytargets
			}
			#else
			#if with_haxe3
			{
				name: "Haxe 3",
				id: "haxe3",
				lixId: "3.4.7",
				env: [],
				jsonOutput: "haxe3.json",
				targets: haxe3targets
			},
			#end
			{
				name: "Haxe 4",
				id: "haxe4",
				lixId: "4.3.2",
				env: [],
				jsonOutput: "haxe4.json",
				targets: haxe4targets
			}, {
				name: "Haxe nightly",
				id: "haxe-nightly",
				lixId: "nightly",
				env: [],
				jsonOutput: "haxe-nightly.json",
				targets: haxeNightlytargets
			}
			#end
		];
		vers;
	};

	static var logPrefix:Array<String> = [];

	static function log(msg:String):Void {
		if ((logPrefix != null) && (logPrefix.length > 0)) {
			Sys.println('[${logPrefix.join(",")}] $msg');
		} else {
			Sys.println(msg);
		}
	}

	static function scmd(cmd:String, ?args:Array<String>):Int {
		var argsText:String = if (args == null) {
			"";
		} else {
			' "' + args.join('" "') + '"';
		}
		log('  * $cmd${argsText}');
		var exitCode:Int = try Sys.command(cmd, args) catch (e:Dynamic) -1;
		if (exitCode != 0) {
			log('  * exit code = $exitCode');
		}
		return exitCode;
	}

	static function mapConcat<T>(maps:Array<Null<Map<String, T>>>):Map<String, T> {
		var ret = new Map<String, T>();
		for (map in maps) {
			if (map != null) {
				for (k => v in map)
					ret[k] = v;
			}
		}
		return ret;
	}

	static function arrConcat<T>(arrs:Array<Null<Array<T>>>):Array<T> {
		var ret = [];
		for (arr in arrs) {
			if (arr != null) {
				ret = ret.concat(arr);
			}
		}
		return ret;
	}

	static function installLibraries(libraries:Null<Map<String, String>>):Int {
		if (libraries != null) {
			for (lib => url in libraries) {
				var libExit:Int = scmd("lix", ["install", "--flat", url]);
				if (libExit != 0) {
					return libExit;
				}
				switch (lib) {
					case "hxnodejs":
						detectedTools.set(HxNodeJs, toolVersionFromHaxeLibraries(lib));
					case "hxjava":
						detectedTools.set(HxJava, toolVersionFromHaxeLibraries(lib));
					case "hxcs":
						detectedTools.set(HxCs, toolVersionFromHaxeLibraries(lib));
					default:
				}
			}
		}
		return 0;
	}

	static function measure(fn:Void->Void):Float {
		var start = haxe.Timer.stamp();
		fn();
		var end = haxe.Timer.stamp();
		return end - start;
	}

	static function compile(version:Version, versionParams:CompileParams, target:Target, compileParams:CompileParams, runParams:RunParams):Bool {
		log('compiling ${target.name} ...');
		var haxeArgs = [];
		if (installLibraries(compileParams.installLibraries) != 0) {
			log("failed to install libraries for compile step - (skipping)");
			return false;
		}
		for (lib in arrConcat([
			version.useLibraries,
			versionParams.useLibraries,
			target.useLibraries,
			compileParams.useLibraries
		])) {
			haxeArgs.push("-lib");
			haxeArgs.push(lib);
		}
		if (compileParams.compileArgs != null) {
			for (arg => val in compileParams.compileArgs) {
				haxeArgs.push(arg);
				if (val != "") {
					haxeArgs.push(val);
				}
			}
		}
		for (define => val in mapConcat([version.defines, versionParams.defines, target.defines, compileParams.defines])) {
			haxeArgs.push("-D");
			haxeArgs.push(val == "" ? define : '$define=$val');
		}
		for (cp in arrConcat([
			version.classPaths,
			versionParams.classPaths,
			target.classPaths,
			compileParams.classPaths
		])) {
			haxeArgs.push("-cp");
			haxeArgs.push(cp);
		}
		if (target.id == "eval") {
			haxeArgs.push("--run");
			haxeArgs.push(compileParams.main);
			if (runParams.args != null)
				haxeArgs = haxeArgs.concat(runParams.args);
		} else {
			haxeArgs.push("-main");
			haxeArgs.push(compileParams.main);
			haxeArgs = haxeArgs.concat(target.compile.split(" "));
		}
		if (scmd("haxe", haxeArgs) != 0)
			return false;
		if (target.postCompile != null && scmd(target.postCompile) != 0)
			return false;
		return true;
	}

	static function run(target:Target, compileParams:CompileParams, runParams:RunParams):Bool {
		if (target.run == null)
			return true;
		log('running ${target.name} ...');
		var runArgs = target.run.replace("Main", compileParams.main.split(".").pop()).split(" ");

		if ((runParams.timeout != null) && HAS_TIMEOUT) {
			runArgs.unshift('${runParams.timeout}');
			runArgs.unshift('${runParams.timeout}');
			runArgs.unshift('-k');
			runArgs.unshift("timeout");
		}
		if (runParams.args != null)
			runArgs = runArgs.concat(runParams.args);
		var runCmd = runArgs.shift();
		return scmd(runCmd, runArgs) == 0;
	}

	public static function benchmarkAll(versionSetup:(haxe:String) -> CompileParams, compileParams:(haxe:String, target:String) -> CompileParams,
			runParams:(haxe:String, target:String) -> RunParams):Void {
		logEnvVars();
		if (!FileSystem.exists("benchmark-run"))
			FileSystem.createDirectory("benchmark-run");
		Sys.setCwd("benchmark-run");

		replaceVERSIONSwhenHaxePR();

		var runDate = Date.now();
		for (version in VERSIONS) {
			logPrefix = [version.id];
			if (VERSION_FILTER != null && !VERSION_FILTER.contains(version.id)) {
				log('skipping ${version.name} (BENCHMARK_VERSIONS)');
				continue;
			}
			var versionParams = versionSetup(version.id);
			if (versionParams == SKIP)
				continue;
			var targets = [
				for (target in version.targets) {
					if (TARGET_FILTER != null && !TARGET_FILTER.contains(target.id)) {
						log('skipping ${target.name} (BENCHMARK_TARGETS)');
						continue;
					}
					target;
				}
			];
			if (targets.length == 0) {
				log('skipping ${version.name} (no targets)');
				continue;
			}
			// version prepare
			log('preparing ${version.name} ...');
			scmd("lix", ["scope", "create"]);
			if (version.lixId != null) {
				if (scmd("lix", ["install", "haxe", version.lixId]) != 0) {
					log('failed to install Haxe ${version.lixId} - (skipping)');
					continue;
				}
				if (scmd("lix", ["use", "haxe", version.lixId]) != 0) {
					log('failed to use Haxe ${version.lixId} - (skipping)');
					continue;
				}
			}
			var resolvedVersion = readVersion("haxe", ["-version"]);
			log('resolved version: $resolvedVersion');
			if (installLibraries(mapConcat([version.installLibraries, versionParams.installLibraries])) != 0) {
				log('failed to download version specific libraries - (skipping)');
				continue;
			}
			var versionOutputs:Array<TargetResult> = [];
			// target setup, compile, and run
			for (target in targets) {
				logPrefix[1] = target.id;
				var compileParams = compileParams(version.id, target.id);
				if (compileParams == SKIP)
					continue;
				var runParams = runParams(version.id, target.id);
				if (target.init != null) {
					log('initialising ${target.name} ...');
					scmd(target.init);
				}
				if (installLibraries(mapConcat([target.installLibraries, compileParams.installLibraries])) != 0) {
					log('failed to download target specific libraries - (skipping)');
					continue;
				}
				var compileTime = 0.0;
				var runTime = 0.0;
				var compileSuccess = true;
				var runSuccess = true;
				if (target.id == "eval") {
					runTime = measure(() -> runSuccess = compile(version, versionParams, target, compileParams, runParams));
					log('run time: $runTime s');
				} else {
					compileTime = measure(() -> compileSuccess = compile(version, versionParams, target, compileParams, runParams));
					log('compile time: $compileTime s (${compileSuccess ? "success" : "FAILED"})');
					if (compileSuccess) {
						runTime = measure(() -> runSuccess = run(target, compileParams, runParams));
						log('run time: $runTime s (${runSuccess ? "success" : "FAILED"})');
					}
				}
				// TODO: record failures
				if (compileSuccess && runSuccess)
					versionOutputs.push({
						name: target.name,
						compileTime: compileTime,
						time: runTime,
						status: Success
					});
			}
			logPrefix.splice(1, logPrefix.length);
			// cleanup
			if (!KEEP_BINARY) {
				scmd("lix", ["scope", "delete"]);
				scmd("rm", ["-rf", "haxe_libraries"]);
				scmd("rm", ["-rf", "out"]);
			}
			// record data
			if (versionOutputs.length > 0) {
				archiveData({
					date: runDate.toString(),
					haxeVersion: resolvedVersion,
					toolVersions: detectedTools,
					targets: versionOutputs
				}, version.jsonOutput, runDate);
			}
		}
	}

	static function archiveData(newRun:TestRun, fileName:String, runDate:Date) {
		var cutoffDate = DateTools.delta(runDate, -DateTools.days(180));
		var cutoffYearMonth = cutoffDate.getFullYear() * 100 + cutoffDate.getMonth() + 1;
		var oldArchive:Array<TestRun> = FileSystem.exists(fileName) ? Json.parse(File.getContent(fileName)) : [];
		var newArchive:Array<TestRun> = [];
		var yearlyArchives = new Map<Int, Array<TestRun>>();
		for (entry in oldArchive) {
			var reg = ~/^([0-9]{4})-([0-9]{2})/;
			if (!reg.match(entry.date)) {
				newArchive.push(entry);
				continue;
			}
			var entryYearMonth = Std.parseInt(reg.matched(1) + reg.matched(2));
			if (entryYearMonth > cutoffYearMonth) {
				newArchive.push(entry);
				continue;
			}
			var entryYear = Std.int(entryYearMonth / 100);
			var yearArchive:Array<TestRun> = [];
			if (yearlyArchives.exists(entryYear)) {
				yearArchive = yearlyArchives.get(entryYear);
			} else {
				yearlyArchives.set(entryYear, yearArchive);
			}
			yearArchive.push(entry);
		}
		for (year => entries in yearlyArchives) {
			var yearFileName = '${fileName}.$year';
			var archive:Array<TestRun> = FileSystem.exists(yearFileName) ? Json.parse(File.getContent(yearFileName)) : [];
			archive = archive.concat(entries);
			File.saveContent(yearFileName, Json.stringify(archive));
		}
		newArchive.push(newRun);
		File.saveContent(fileName, Json.stringify(newArchive));
	}

	static function replaceVERSIONSwhenHaxePR() {
		var haxePR:Null<String> = Sys.getEnv("BENCHMARK_HAXE_PR");
		if (haxePR == null || haxePR.length <= 0) {
			return;
		}
		log('BENCHMARK_HAXE_PR=$haxePR');
		var versions:Array<Version> = VERSIONS.filter(v -> v.id == "haxe-nightly");
		if (versions.length != 1) {
			log("Haxe nightly version not found - no Haxe PR run!!");
			return;
		}
		var version:Version = versions[0];
		version.id = "haxe-pr";
		version.name = 'Haxe $haxePR';

		version.lixId = haxePR;
		version.jsonOutput = "haxe-pr.json";
		VERSIONS = [version];
		detectedTools.set(HaxePR, haxePR);
	}

	static function detectToolVersions():Map<Tool, String> {
		var toolVersions:Map<Tool, String> = new Map<Tool, String>();
		toolVersions.set(Php, extractWord(readVersion("php", ["-v"]), 1));
		toolVersions.set(Mono, extractWord(readVersion("mono", ["--version"]), 4));
		toolVersions.set(Python, extractWord(readVersion("python", ["--version"]), 1));
		toolVersions.set(Lua, extractWord(readVersion("lua", ["-v"]), 1));
		toolVersions.set(LuaJit, extractWord(readVersion("luajit", ["-v"]), 1));
		toolVersions.set(NodeJs, readVersion("nodejs", ["--version"]));
		toolVersions.set(Java, extractWord(readVersion("java", ["--version"]), 1));

		// TODO automatically detect hxcpp and HL versions
		toolVersions.set(Hl, "1.13");

		return toolVersions;
	}

	static function toolVersionFromHaxeLibraries(lib:String):String {
		var content:String = File.getContent(Path.join(["haxe_libraries", lib + ".hxml"]));
		var lines:Array<String> = content.split("\n").filter(l -> l.startsWith("-cp"));

		if (lines.length != 1) {
			return "unknown";
		}
		var reg:EReg = ~/([^\/]+)\/haxelib/;
		if (reg.match(lines[0])) {
			return reg.matched(1);
		}
		reg = ~/github\/([a-fA-F0-9]+)/;
		if (reg.match(lines[0])) {
			return reg.matched(1);
		}
		return "unknown";
	}

	static function extractWord(text:String, index:Int):String {
		if ((text == null) || (text.length <= 0)) {
			return "";
		}
		var parts:Array<String> = text.split(" ");
		if (parts.length < index) {
			return text;
		}
		return parts[index];
	}

	static function readVersion(command:String, args:Array<String>):String {
		try {
			var proc = new sys.io.Process(command, args);
			proc.exitCode();
			var version = (proc.stdout.readAll().toString() + proc.stderr.readAll().toString()).trim();
			proc.close();
			return version;
		} catch (e:Dynamic) {
			return "n/a";
		}
	}

	static function logEnvVars() {
		if (VERSION_FILTER == null) {
			log('BENCHMARK_VERSIONS not set - running all Haxe versions');
		} else {
			log('BENCHMARK_VERSIONS=$VERSION_FILTER');
		}

		if (TARGET_FILTER == null) {
			log('BENCHMARK_TARGETS not set - running all targets');
		} else {
			log('BENCHMARK_TARGETS=$TARGET_FILTER');
		}

		if (KEEP_BINARY) {
			log('BENCHMARK_KEEP_BINARY=keep');
		} else {
			log('BENCHMARK_KEEP_BINARY not set, wiping output folder after each run');
		}

		if (HAS_TIMEOUT) {
			log('using timeout to limit runtime');
		} else {
			log('not using timeout');
		}
	}
}
