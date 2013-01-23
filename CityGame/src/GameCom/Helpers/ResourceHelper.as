package GameCom.Helpers {
	import adobe.utils.CustomActions;
	import flash.utils.ByteArray;
	import GameCom.Managers.MissionManager;
	import GameCom.SystemComponents.ResourceInformation;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class ResourceHelper {
		
		private static var Resources:Vector.<ResourceInformation>;
		
		private static var CurrentResourcesUnlocked:int = 0;
		private static var CurrentReputation:int = 0;
		
		public static function Initialize():void {
			Resources = new Vector.<ResourceInformation>();
			
			var bytes:ByteArray = ThemeManager.Get("Resources.csv");
			bytes.position = 0;
			var lines:Array = bytes.readUTFBytes(bytes.length).split("\n");
			
			//Array starts at 1 because theres a header line.
			for (var i:int = 1; i < lines.length; i++) {
				var b:Array = (lines[i] as String).split(",");
				var ri:ResourceInformation = new ResourceInformation(b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7]);
				Resources.push(ri);
			}
		}
		
		public static function GenerateRandomMission():void {
			var rR:ResourceInformation = Resources[Math.floor(Resources.length * Math.random())];
			
			var total:int = rR.MinimumLoad + Math.floor(Math.random() * (rR.MaximumLoad - rR.MinimumLoad));
			
			MissionManager.SetDeliveryResources(rR.ID, total);
		}
		
		public static function GetResouce(rID:int):ResourceInformation {
			return Resources[rID];
		}
		
	}

}