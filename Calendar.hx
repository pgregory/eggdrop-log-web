import js.Dom;
import haxe.Http;

class Calendar {
	public static function main() {
	}

	public static function getCalendar(yearNum, monthNum, dayNum) {
		var cnx = new Http("/index.n/calendar?year="+yearNum+"&month="+monthNum+"&day="+dayNum);
		cnx.onData = function(data) {
			var div = js.Lib.document.getElementById("navigation");
			div.innerHTML = data;
		}
		cnx.onError = function(msg) { js.Lib.alert("Error: " + msg); };
		cnx.request(false);
	}
}
