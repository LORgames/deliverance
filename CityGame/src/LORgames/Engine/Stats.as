package LORgames.Engine 
{
	/**
	 * ...
	 * @author Paul
	 */
	public class Stats {
		
		public static function AddOne(statname:String):void {
			var stat:int = Storage.GetAsInt(statname, 0);
			stat++;
			Storage.Set(statname, stat);
		}
		
		public static function SetHighestInt(statname:String, newHighest:int):void {
			if (Storage.GetAsInt(statname, 0) < newHighest) {
				Storage.Set(statname, newHighest);
			}
		}
		
		public static function SetLowestInt(statname:String, newLowest:int):void {
			if (Storage.GetAsInt(statname, 0) > newHighest) {
				Storage.Set(statname, newHighest);
			}
		}
		
		public static function SetHighestNumber(statname:String, newHighest:Number):void {
			if (Storage.GetAsNumber(statname, 0) < newHighest) {
				Storage.Set(statname, newHighest);
			}
		}
		
		public static function SetLowestNumber(statname:String, newLowest:Number):void {
			if (Storage.GetAsNumber(statname, 0) > newHighest) {
				Storage.Set(statname, newHighest);
			}
		}
		
	}

}