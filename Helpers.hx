class Helpers {
	public function new() {
	}

	public function truncatePercentage(p : Float) : String {
		return Std.string(p).substr(0, Std.string(p).indexOf('.')+3);
	}
	
	public function padInteger(value:Int, length:Int) : String {
		return StringTools.lpad(Std.string(value), "0", length);
	}

	public function prevMonthParams(yearNum:Int, monthNum:Int, dayNum:Int) {
		var monthNum = monthNum - 1;
		if(monthNum < 0) {
			monthNum = 11;
			yearNum -= 1;
		}
		var date : Date = new Date(yearNum, monthNum, dayNum, 0, 0, 0);
		if(DateTools.getMonthDays(date) < dayNum) {
			dayNum = DateTools.getMonthDays(date);
		}
		return "/index.n?year="+yearNum+"&month="+monthNum+"&day="+dayNum;
	}

	public function nextMonthParams(yearNum:Int, monthNum:Int, dayNum:Int) {
		var monthNum = monthNum + 1;
		if(monthNum > 11) {
			monthNum = 0;
			yearNum += 1;
		}
		var date : Date = new Date(yearNum, monthNum, dayNum, 0, 0, 0);
		if(DateTools.getMonthDays(date) < dayNum) {
			dayNum = DateTools.getMonthDays(date);
		}
		return "/index.n?year="+yearNum+"&month="+monthNum+"&day="+dayNum;
	}

	public function prevYearParams(yearNum:Int, monthNum:Int, dayNum:Int) {
		return "/index.n?year="+(yearNum-1)+"&month="+monthNum+"&day="+dayNum;
	}

	public function nextYearParams(yearNum:Int, monthNum:Int, dayNum:Int) {
		return "/index.n?year="+(yearNum+1)+"&month="+monthNum+"&day="+dayNum;
	}
}
