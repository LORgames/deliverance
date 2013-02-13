package LORgames.Engine.StatServers 
{
	import mochi.as3.MochiEvents;
	import mochi.as3.MochiServices;
	/**
	 * ...
	 * @author Paul
	 */
	public class MochiMediaStats implements IStatServer {
		
		private var isWorking:Boolean = true;
		
		public function MochiMediaStats() {
			trace("using mochi stats: UNSUPPORTED ANALYTICS =(");
			MochiServices.connect("c3ebe5c39a9741ba", Main.GetStage(), onConnectError);
		}
		
		private function onConnectError(str:String):void {
			//trace("mochi stats error: " + str);
			//isWorking = false;
		}
		
		public function StartLevel(level:String):void {
			MochiEvents.startPlay(level);
		}
		
		public function EndLevel():void {
			MochiEvents.endPlay();
		}
		
		public function Submit(statname:String, statvalue:int):void {
			//TODO: Redirect this API elsewhere?
			//if(isWorking) {
			//	MochiEvents.trackEvent(statname, statvalue);
			//}
		}
		
	}

}