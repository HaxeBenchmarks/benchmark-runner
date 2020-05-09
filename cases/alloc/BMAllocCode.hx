import haxe.io.Bytes;

class BMAllocCode {
	public function new() {
		var count:Int = 500000;

		allocBytes(count, 100);
		allocBytes(count, 1000);
		allocBytes(count, 101);
		allocBytes(count, 1001);
		allocBytes(count, 102);
	}

	function allocBytes(count:Int, size:Int) {
		var data:Array<Bytes> = [];
		for (i in 0...count) {
			var bytes:Bytes = Bytes.alloc(size);
			bytes.fill(0, size, i);
			data.push(bytes);
		}
		for (i in 0...count) {
			var bytes:Bytes = Bytes.alloc(size);
			bytes.fill(0, size, i);
			bytes.compare(data[i]);
		}
	}

	static function main() {
		try {
			new BMAllocCode();
		} catch (e:Any) {
			trace(e);
		}
	}
}
