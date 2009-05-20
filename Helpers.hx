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
		return "javascript:Calendar.getCalendar("+yearNum+", "+monthNum+", "+dayNum+")";
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
		return "javascript:Calendar.getCalendar("+yearNum+", "+monthNum+", "+dayNum+")";
	}

	public function prevYearParams(yearNum:Int, monthNum:Int, dayNum:Int) {
		return "javascript:Calendar.getCalendar("+(yearNum-1)+", "+monthNum+", "+dayNum+")";
	}

	public function nextYearParams(yearNum:Int, monthNum:Int, dayNum:Int) {
		return "javascript:Calendar.getCalendar("+(yearNum+1)+", "+monthNum+", "+dayNum+")";
	}

	public function dayName(dayNum : Int) : String {
		return App.dayNumbertoName.get(dayNum);
	}

	public function monthName(monthNum : Int) : String {
		return App.monthNumbertoName.get(monthNum);
	}

	public function dayDateName(dayNum : Int) : String {
		var suffix : String = "th";
		if(dayNum == 1 || dayNum == 21 || dayNum == 31 ) {
			suffix = "st";
		} else if(dayNum == 2 || dayNum == 22) {
			suffix = "nd";
		} else if(dayNum == 3 || dayNum == 23) {
			suffix = "rd";
		}
		return Std.string(dayNum) + suffix;
	}
}
