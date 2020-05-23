import haxe.crypto.Sha512;

class BMSHA512Code {
	public function new() {
		var allHash:StringBuf = new StringBuf();
		for (index in 0...10) {
			for (text in Data.DATA) {
				allHash.add(Sha512.encode(text));
			}
		}

		Sha512.encode(Data.DATA.join(""));
		Sha512.encode(allHash.toString());
	}

	static function main() {
		try {
			new BMSHA512Code();
		} catch (e:Any) {
			trace(e);
			Sys.exit(1);
		}
	}
}
