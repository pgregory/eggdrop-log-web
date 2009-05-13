class Helpers {
	public function new() {
	}

	public function truncatePercentage(p : Float) : String {
		return Std.string(p).substr(0, Std.string(p).indexOf('.')+3);
	}
	
	public function padInteger(value:Int, length:Int) : String {
		return StringTools.lpad(Std.string(value), "0", length);
	}

	public function prevMonthParams(yearNum:Int, monthNum:Int) {
		var prevMonthNum = monthNum - 1;
		if(prevMonthNum < 0) {
			prevMonthNum = 11;
			yearNum -= 1;
		}
		return "/index.n?year="+yearNum+"&month="+prevMonthNum;
	}

	public function nextMonthParams(yearNum:Int, monthNum:Int) {
		var nextMonthNum = monthNum + 1;
		if(nextMonthNum > 11) {
			nextMonthNum = 0;
			yearNum += 1;
		}
		return "/index.n?year="+yearNum+"&month="+nextMonthNum;
	}
}
