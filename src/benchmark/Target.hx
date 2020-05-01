package benchmark;

typedef Target = CompileParams &
	RunParams & {
	// Human-readable identifier
	var name:String;
	// Identifier suitable for file/directory names
	var id:String;
	// Compiler invocation for Haxe
	var compile:String;
	// Additional command after Haxe compilation
	var ?postCompile:String;
	// Command to run output
	var ?run:String;
	// Command to initialise the target (executed before any compilation)
	var ?init:String;
};
