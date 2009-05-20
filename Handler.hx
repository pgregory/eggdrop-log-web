class Handler extends mtwin.web.Handler<Void> {
	public function new() {
		super();
		free("default", "main.mtt", doMain);
		free("search", "search.mtt", doSearch);
		free("calendar", "month.mtt", doCalendar);

	}

	public function doMain() {
		doCalendar();

		// Get the month, year and day from the params.
		var date : Date = getDate();
		var yearNum : Int = date.getFullYear();
		var monthNum : Int = date.getMonth();
		var dayNum : Int = date.getDate();

		var logLines : List<Dynamic> = new List<Dynamic>(); 
		var logFile : String = App.logPath + "aqsis.log." + StringTools.lpad(Std.string(dayNum), "0", 2) + App.monthNumbertoName.get(monthNum) + yearNum;
		var time_r = ~/\[([0-9]+):([0-9]+)\] (.*)$/;
		var action_r = ~/Action: (.*)$/;
		var user_r = ~/<([^>]+)> (.*)$/;
		if(neko.FileSystem.exists(logFile)) {
			var logFileContent : Array<String> = ["No logs for that day"];
			logFileContent = neko.io.File.getContent(logFile).split("\n");
			for(line in logFileContent) {
				if(time_r.match(line)) {
					var time : Date = Date.fromString(time_r.matched(1) + ":" + time_r.matched(2) + ":00");
					var rest : String = time_r.matched(3);
					if(action_r.match(rest)) {
						logLines.add({time:time, type:1, rest:action_r.matched(1)});
					} else if(user_r.match(rest)) {
						logLines.add({time:time, type:2, user:user_r.matched(1), rest:user_r.matched(2)});
					} else {
						logLines.add({time:time, type: 0, rest:rest});
					}
				}
			}
		}
		App.context.logFile = logFile;
		App.context.logLines = logLines;
	}

	function doSearch() {
		var query = neko.Web.getParams().get("query");
		if(query == null || query == "") {
			neko.Web.redirect("/index.n");
		}
		var results : List<String> = new List<String>();
		var result_values : List<Date> = new List<Date>();
		var output : String = new neko.io.Process("namazu", ["-l", query, App.basePath + "/search"]).stdout.readAll().toString();
		output = StringTools.rtrim(output);
		if(output.length != 0) {
			results = Lambda.map(output.split("\n"), function(r) { return new neko.io.Path(r).ext; });
			var split = function(e) {
				var r = ~/([0-9]+)([A-Za-z]+)([0-9]+)/;
				if(!r.match(e)) {
					throw("Error: invalid result data");
				} else {
					var date : Date = new Date(Std.parseInt(r.matched(3)), App.monthNametoNumber.get(r.matched(2)), Std.parseInt(r.matched(1)), 0, 0, 0);
					return date;
				}
			}
			result_values = results.map(split);
		}

		App.context.helpers = new Helpers();
		App.context.results = results;
		App.context.result_values = result_values;
		App.context.query = query;
	}

	function doCalendar() {
		// Get the month, year and day from the params.
		var date : Date = getDate();
		var yearNum : Int = date.getFullYear();
		var monthNum : Int = date.getMonth();
		var dayNum : Int = date.getDate();

		var files : Array<String> = neko.FileSystem.readDirectory(App.logPath);
		var logFiles : List<String> = Lambda.filter(files, function(f) { return !neko.FileSystem.isDirectory(App.logPath + f); });

		var month : List<Dynamic> = getMonth(yearNum, monthNum, logFiles);

		date = new Date(yearNum, monthNum, dayNum, 0, 0, 0);
		App.context.helpers = new Helpers();
		App.context.month = month;
		App.context.yearNum = yearNum;
		App.context.monthNum = monthNum;
		App.context.dayNum = dayNum;
		App.context.dayName = App.dayNumbertoName.get(date.getDay());
		App.context.monthName = App.monthNumbertoName.get(monthNum);
	}

	function getDate() : Date {
		var yearNum : Int = App.request.getInt("year");
		var monthNum : Int = App.request.getInt("month");
		var dayNum : Int = App.request.getInt("day");
		var date : String = App.request.get("date", "");
		if(date == "") {
			return if(yearNum == null || monthNum == null || dayNum == null) Date.now() else new Date(yearNum, monthNum, dayNum, 0, 0, 0);
		} else {
			var r = ~/([0-9][0-9][0-9][0-9])([0-9][0-9])([0-9][0-9])/;
			if(r.match(date)) {
				return new Date(Std.parseInt(r.matched(1)), Std.parseInt(r.matched(2))-1, Std.parseInt(r.matched(3)), 0, 0, 0);
			} else {
				return Date.now();
			}
		}
	}

	function getMonth(yearNum : Int, monthNum : Int, logFiles : List<String>) : Dynamic {
		// Get the list of dates for which there are logs available.
		var logs : IntHash<Dynamic> = new IntHash<Dynamic>();
		var s : String = "aqsis\\.log\\.([0-9]+)" + App.monthNumbertoName.get(monthNum) + yearNum;
		var r : EReg = new EReg(s, "");
		var startDate = new Date(yearNum, monthNum, 1, 0, 0, 0);
		var startDay : Int = startDate.getDay();
		var dayNum : Int = -(startDay-1);
		
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
				var week : Int = Math.floor((dayNum + startDay - 0.5) / 7);
				var date : Date = new Date(yearNum, monthNum, dayNum, 0,0,0);
				var weekDay : Int = date.getDay();
				weeksList[week][weekDay].log = logfile;
			}
		}

		var month : {daycount : Int, weeks : Dynamic};
		month = {daycount:DateTools.getMonthDays(startDate),weeks:weeksList};
		return month;
	}


	override function prepareTemplate( t:String ) {
		App.template = new mtwin.templo.Loader(t);
	}
}
