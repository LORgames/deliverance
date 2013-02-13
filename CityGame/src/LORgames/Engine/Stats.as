package LORgames.Engine {
	import flash.display.LoaderInfo;
	import LORgames.Engine.StatServers.IStatServer;
	import LORgames.Engine.StatServers.KongregateStats;
	import LORgames.Engine.StatServers.MochiMediaStats;
	/**
	 * ...
	 * @author Paul
	 */
	public class Stats {
		private static var statServer:IStatServer;
		
		public static function Connect():void {
			if (LoaderInfo(Main.GetStage().loaderInfo).parameters.kongregate_api_path) {
				statServer = new KongregateStats();
			} else {
				statServer = new MochiMediaStats();
			}
		}
		
		public static function AddOne(statname:String):void {
			var stat:int = Storage.GetAsInt(statname, 0);
			stat++;
			Storage.Set(statname, stat);
			
			statServer.Submit(statname, stat);
		}
		
		public static function AddValue(statname:String, increaseValue:int):void {
			var stat:int = Storage.GetAsInt(statname, 0);
			stat += increaseValue;
			Storage.Set(statname, stat);
			
			statServer.Submit(statname, stat);
		}
		
		public static function SetHighestInt(statname:String, newHighest:int):void {
			if (Storage.GetAsInt(statname, 0) < newHighest) {
				Storage.Set(statname, newHighest);
				statServer.Submit(statname, newHighest);
			}
		}
		
		public static function SetLowestInt(statname:String, newLowest:int):void {
			if (Storage.GetAsInt(statname, 0) > newLowest) {
				Storage.Set(statname, newLowest);
				statServer.Submit(statname, newLowest);
			}
		}
		
		public static function SetHighestNumber(statname:String, newHighest:Number):void {
			if (Storage.GetAsNumber(statname, 0) < newHighest) {
				Storage.Set(statname, newHighest);
				statServer.Submit(statname, newHighest);
			}
		}
		
		public static function SetLowestNumber(statname:String, newLowest:Number):void {
			if (Storage.GetAsNumber(statname, 0) > newLowest) {
				Storage.Set(statname, newLowest);
				statServer.Submit(statname, newLowest);
			}
		}
		
		public static function StartLevel(CurrentLevel:int):void {
			statServer.StartLevel("level_" + CurrentLevel);
		}
		
		public static function EndLevel():void {
			statServer.EndLevel();
		}
		
	}

}