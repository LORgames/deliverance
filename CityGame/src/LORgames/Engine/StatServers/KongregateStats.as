package LORgames.Engine.StatServers 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	import LORgames.Engine.MessageBox;
	/**
	 * ...
	 * @author Paul
	 */
	public class KongregateStats implements IStatServer {
		
		private var kongregate:*;
		private var loader:Loader = new Loader();
		
		public function KongregateStats() {
			trace("using kong stats");
			
			// Pull the API path from the FlashVars
			var paramObj:Object = LoaderInfo(Main.GetStage().loaderInfo).parameters;
			
			// The API path. The "shadow" API will load if testing locally.
			var apiPath:String = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);

			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(request);
		}
		
		private function loadComplete(event:Event):void {
			// Save Kongregate API reference
			kongregate = event.target.content;
			Main.GetStage().addChild(kongregate);
			
			// Connect to the back-end
			try {
				kongregate.services.connect();
			} catch (ex:Error) {
				new MessageBox("Connect error:\n" + ex.name + "\n\n" + ex.message, 0, null, "OK?");
			}
			
			// You can now access the API via:
			// kongregate.services
			// kongregate.user
			// kongregate.scores
			// kongregate.stats
			// etc...
		}
		
		public function StartLevel(levelID:String):void {}
		public function EndLevel():void {}
		
		public function Submit(statname:String, statvalue:int):void {
			if (statname.indexOf("stat_") == 0) {
				try {
					kongregate.stats.submit(statname.substr(5), statvalue);
				} catch (ex:Error) {
					new MessageBox("A wild Kongregate Bug has appeared!\n\n " + ex.name + "\n\n" + ex.message, 0, null, "OK?");
				}
			}
			
		}
		
	}

}