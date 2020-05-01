package benchmark;

typedef RunParams = {
	// Command-line arguments to pass to the application (default: none)
	var ?args:Array<String>;
	// Timeout in seconds (default: no timeout)
	var ?timeout:Int;
	// Number of times to repeat (default: 1)
	var ?repeatCount:Int;
};
