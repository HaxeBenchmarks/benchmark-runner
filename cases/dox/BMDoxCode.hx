class BMDoxCode {
	@:access(dox.Dox)
	public static function main() {
		try {
			dox.Dox.main();
		} catch (e:Any) {
			trace(e);
			Sys.exit(1);
		}
	}
}
