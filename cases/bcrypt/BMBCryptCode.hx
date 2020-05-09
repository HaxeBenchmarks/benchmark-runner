import haxe.crypto.BCrypt;

class BMBCryptCode {
	private static inline var LIMIT_DATA:Int = 24;

	public function new() {
		var allHashes:Array<String> = [];
		for (index in 0...LIMIT_DATA) {
			var text:String = Data.DATA[index];
			var salt:String = BCrypt.generateSalt(6 + (index % 6));
			allHashes.push(BCrypt.encode(text, salt));
		}

		for (index in 0...LIMIT_DATA) {
			BCrypt.verify(Data.DATA[index], allHashes[index]);
		}
	}

	static function main() {
		try {
			new BMBCryptCode();
		} catch (e:Any) {
			trace(e);
		}
	}
}
