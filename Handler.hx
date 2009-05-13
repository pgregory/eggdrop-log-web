class Handler extends mtwin.web.Handler<Void> {
	static var monthNametoNumber : Hash<Int>;
	static var monthNumbertoName : IntHash<String>;
	static var dayNumbertoName : IntHash<String>;

	public function new() {
		super();
		free("default", "calendar.mtt", doCalendar);
		monthNametoNumber = new Hash<Int>();
		monthNumbertoName = new IntHash<String>();
		dayNumbertoName = new IntHash<String>();

		monthNametoNumber.set("Jan", 0);
		monthNametoNumber.set("Feb", 1);
		monthNametoNumber.set("Mar", 2);
		monthNametoNumber.set("Apr", 3);
		monthNametoNumber.set("May", 4);
		monthNametoNumber.set("Jun", 5);
		monthNametoNumber.set("Jul", 6);
		monthNametoNumber.set("Aug", 7);
		monthNametoNumber.set("Sep", 8);
		monthNametoNumber.set("Oct", 9);
		monthNametoNumber.set("Nov", 10);
		monthNametoNumber.set("Dec", 11);

		monthNumbertoName.set(0, "Jan");
		monthNumbertoName.set(1, "Feb");
		monthNumbertoName.set(2, "Mar");
		monthNumbertoName.set(3, "Apr");
		monthNumbertoName.set(4, "May");
		monthNumbertoName.set(5, "Jun");
		monthNumbertoName.set(6, "Jul");
		monthNumbertoName.set(7, "Aug");
		monthNumbertoName.set(8, "Sep");
		monthNumbertoName.set(9, "Oct");
		monthNumbertoName.set(10, "Nov");
		monthNumbertoName.set(11, "Dec");

		dayNumbertoName.set(0, "Sunday");
		dayNumbertoName.set(1, "Monday");
		dayNumbertoName.set(2, "Tuesday");
		dayNumbertoName.set(3, "Wednesday");
		dayNumbertoName.set(4, "Thursday");
		dayNumbertoName.set(5, "Friday");
		dayNumbertoName.set(6, "Saturday");
	}

	public function doCalendar() {
		// Get the month, year and day from the params.
		var date : Date = Date.now();
		var yearNum : Int = App.request.getInt("year");
		var monthNum : Int = App.request.getInt("month");
		var dayNum : Int = App.request.getInt("day");
		yearNum = if(yearNum == null) date.getFullYear() else yearNum;
		monthNum = if(monthNum == null) date.getMonth() else monthNum;
		dayNum = if(dayNum == null) date.getDate() else dayNum;

		var files : Array<String> = neko.FileSystem.readDirectory(App.logPath);
		var logFiles : List<String> = Lambda.filter(files, function(f) { return !neko.FileSystem.isDirectory(App.logPath + f); });

		var month : List<Dynamic> = getMonth(yearNum, monthNum, logFiles);

		var logLines : List<{time:Date, line:String}> = new List<{time:Date, line:String}>(); 
		var logFile : String = App.logPath + "aqsis.log." + StringTools.lpad(Std.string(dayNum), "0", 2) + monthNumbertoName.get(monthNum) + yearNum;
		var r = ~/\[([0-9]+):([0-9]+)\] (.*)$/;
		if(neko.FileSystem.exists(logFile)) {
			var logFileContent : Array<String> = ["No logs for that day"];
			logFileContent = neko.io.File.getContent(logFile).split("\n");
			for(line in logFileContent) {
				if(r.match(line)) {
					var time : Date = Date.fromString(r.matched(1) + ":" + r.matched(2) + ":00");
					logLines.add({time:time, line:r.matched(3)});
				}
			}
		}

		App.context.helpers = new Helpers();
		App.context.month = month;
		App.context.yearNum = yearNum;
		App.context.monthNum = monthNum;
		App.context.dayNum = dayNum;
		App.context.dayName = dayNumbertoName.get(dayNum);
		App.context.monthName = monthNumbertoName.get(monthNum);
		App.context.logFile = logFile;
		App.context.logLines = logLines;
	}

	function getMonth(yearNum : Int, monthNum : Int, logFiles : List<String>) : Dynamic {
		// Get the list of dates for which there are logs available.
		var logs : IntHash<Dynamic> = new IntHash<Dynamic>();
		var s : String = "aqsis\\.log\\.([0-9]+)" + monthNumbertoName.get(monthNum) + yearNum;
		var r : EReg = new EReg(s, "");
		var startDate = new Date(yearNum, monthNum, 0, 0, 0, 0);
		var startDay : Int = startDate.getDay();
		var dayNum : Int = -startDay;
		
		var weeksList : Array<Array<{day:Int, log:String}>> = new Array<Array<{day:Int, log:String}>>();
		for(week in 0...6) {
			weeksList.push(new Array<{day:Int, log:String}>());
			for(day in 0...7) {
				weeksList[week].push({day:dayNum, log:""});
				dayNum++;
			}
		}

		for(logfile in logFiles) {
			if(r.match(logfile)) {
				var day : String  = r.matched(1);
				var dayNum : Int = Std.parseInt(day);
				var week : Int = Math.floor((dayNum + startDay + 0.5) / 7);
				var date : Date = new Date(yearNum, monthNum, dayNum, 0,0,0);
				var weekDay : Int = date.getDay();
				weeksList[week][weekDay].log = logfile;
			}
		}

		var month : {month : Int, daycount : Int, weeks : Dynamic};
		month = {month:monthNum, daycount:DateTools.getMonthDays(startDate),weeks:weeksList};
		return month;
	}


	override function prepareTemplate( t:String ) {
		App.template = new mtwin.templo.Loader(t);
	}
}
