package GameCom.Helpers {
	import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	import GameCom.Managers.MissionManager;
	import GameCom.SystemComponents.ResourceInformation;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class UpgradeHelper {
		private static var Costs:Array = new Array();
		private static var Benefits:Array = new Array();
		
		public static function Initialize():void {
			var bytes:ByteArray = ThemeManager.Get("Upgrades.csv");
			bytes.position = 0;
			var lines:Array = bytes.readUTFBytes(bytes.length).split("\n");
			
			//Loop starts at 1 because theres a header line.
			for (var i:int = 1; i < lines.length; i++) {
				var d:Array = lines[i].split(',');
				
				Costs[d[0] + d[1]] = d[2];
				Benefits[d[0] + d[1]] = d[4];
			}
		}
		
		public static function GetCost(stat:String, level:int):int {
			return Costs[stat + level];
		}
		
		public static function GetBenefit(stat:String, level:int):String {
			if(Benefits[stat + level]) {
				return Benefits[stat + level];
			}
			
			return "";
		}
	}

}