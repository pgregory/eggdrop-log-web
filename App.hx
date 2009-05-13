class App {
	public static var request : mtwin.web.Request;

	public static var template : mtwin.templo.Loader;

	public static var context : Dynamic;

	public static var basePath : String;
	public static var tmpPath : String;
	public static var logPath : String;

	public static function main() {
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
