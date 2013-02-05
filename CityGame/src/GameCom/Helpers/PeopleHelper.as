package GameCom.Helpers 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class PeopleHelper {
		public static var Names:Vector.<String>;
		public static var Message:Vector.<String>;
		
		public static function Initialize():void {
			Names = new Vector.<String>();
			Message = new Vector.<String>();
			
			var bytes:ByteArray = ThemeManager.Get("Characters.csv");
			bytes.position = 0;
			var lines:Array = bytes.readUTFBytes(bytes.length).split("\n");
			
			//Loop starts at 1 because theres a header line.
			for (var i:int = 0; i < lines.length; i++) {
				var b:Array = (lines[i] as String).split("|");
				
				if(b[1] != "Unused") {
					Names.push(b[1]);
					Message.push(b[2]);
				}
			}
		}
		
		public static function GetAvailableNPC(npcs:int):int {
			var attempts:int = 0;
			
			while (attempts < 5) {
				var tried:int = Math.floor(Math.random() * Names.length);
				
				if ((npcs & (0x1 << tried)) > 0) {
					return tried;
				}
				
				attempts++;
			}
			
			return 0;
		}
		
	}

}