class Helpers {
	public function new() {
	}

	public function truncatePercentage(p : Float) : String {
		return Std.string(p).substr(0, Std.string(p).indexOf('.')+3);
	}
	
	public function padInteger(value:Int, length:Int) : String {
		return StringTools.lpad(Std.string(value), "0", length);
	}
}
