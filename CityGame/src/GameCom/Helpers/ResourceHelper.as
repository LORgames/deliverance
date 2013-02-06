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
		private static var CurrentResourcesUnlockedIndex:uint = 0;
		
		public static function Initialize():void {
			Resources = new Vector.<ResourceInformation>();
			
			var bytes:ByteArray = ThemeManager.Get("Resources.csv");
			bytes.position = 0;
			var lines:Array = bytes.readUTFBytes(bytes.length).split("\n");
			
			//Loop starts at 1 because theres a header line.
			for (var i:int = 1; i < lines.length; i++) {
				var b:Array = (lines[i] as String).split(",");
				var ri:ResourceInformation = new ResourceInformation(b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7]);
				Resources.push(ri);
			}
			
			while (Resources[CurrentResourcesUnlockedIndex + 1].ReputationForUnlock <= ReputationHelper.GetCurrentLevel()) {
				CurrentResourcesUnlockedIndex++;
			}
		}
		
		public static function GetResouce(rID:int):ResourceInformation {
			return Resources[rID];
		}
		
		public static function GetAvailableResource(resources:int):ResourceInformation {
			var attempts:int = 0;
			
			while (attempts < 5) {
				var tried:int = Math.floor(Math.random() * CurrentResourcesUnlockedIndex);
				
				if ((resources & (0x1 << tried)) > 0) {
					return Resources[tried];
				}
				
				attempts++;
			}
			
			return null;
		}
		
		public static function pad(num:uint, minLength:uint):String {
			var str:String = num.toString(2);
			while (str.length < minLength) str = "0" + str;
			return str;
		}
		
		public static function HasSupportedResources(resource:uint):Boolean {
			if (CurrentResourcesUnlockedIndex == 32) return true;
			
			if (((0x7FFFFFFF >> (31-CurrentResourcesUnlockedIndex)) & resource) > 0) {
				return true;
			}
			
			return false;
		}
		
	}

}