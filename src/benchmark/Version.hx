package benchmark;

typedef Version = CompileParams & {
	// Human-readable identifier
	var name:String;
	// Identifier suitable for file/directory names
	var id:String;
	// Identifier when installing with lix
	var lixId:String;
	// Environment variables to use with this version
	var env:Map<String, String>;
	// Path to JSON output file
	var jsonOutput:String;
	// Targets usable with this version
	var targets:Array<Target>;
};
