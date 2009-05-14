class App {
	public static var request : mtwin.web.Request;

	public static var template : mtwin.templo.Loader;

	public static var context : Dynamic;

	public static var basePath : String;
	public static var tmpPath : String;
	public static var logPath : String;

	public static var monthNametoNumber : Hash<Int>;
	public static var monthNumbertoName : IntHash<String>;
	public static var dayNumbertoName : IntHash<String>;

	public static function main() {
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

		mtwin.templo.Loader.BASE_DIR = neko.Web.getCwd() + "templates/";
		mtwin.templo.Loader.TMP_DIR = neko.Web.getCwd() + "compiled/";
		mtwin.templo.Loader.MACROS = "macros.mtt";
		mtwin.templo.Loader.OPTIMIZED = false;
		context = {};
		template = null;
		basePath = neko.Web.getCwd();
		tmpPath = neko.Web.getCwd() + "tmp/";
		logPath = neko.Web.getCwd() + "logs/";

		request = new mtwin.web.Request();
		var handler = new Handler();

		var level = if(request.getPathInfoPart(0) == "index.n") 1 else 0;

		handler.execute(request, level);

		if(template != null) {
			neko.Web.setHeader("Context-Type", "text/html; charset=UTF-8");
			neko.Lib.print(template.execute(context));
		}
	}
}
