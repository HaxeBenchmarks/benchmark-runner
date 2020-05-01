package benchmark;

typedef CompileParams = {
	// Haxelibs to install (key is lib name, value is lix URL)
	var ?installLibraries:Map<String, String>;
	// Haxelibs to use (-lib when compiling)
	var ?useLibraries:Array<String>;
	// Compile-time defines (-D foo=bar or empty value for -D foo)
	var ?defines:Map<String, String>;
	// Class paths (-cp when compiling)
	var ?classPaths:Array<String>;
	// Main class (-main when compiling)
	var ?main:String;
	// Build macros to invoke (--macro when compiling)
	var ?buildMacros:Array<String>;
};
