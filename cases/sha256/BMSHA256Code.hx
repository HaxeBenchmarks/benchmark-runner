import haxe.crypto.Sha256;

class BMSHA256Code {
	public function new() {
		var allHash:StringBuf = new StringBuf();
		for (index in 0...100) {
			for (text in Data.DATA) {
				allHash.add(Sha256.encode(text));
			}
		}

		Sha256.encode(Data.DATA.join(""));
		Sha256.encode(allHash.toString());
	}

	static function main() {
		try {
			new BMSHA256Code();
		} catch (e:Any) {
			trace(e);
			Sys.exit(1);
		}
	}
}
