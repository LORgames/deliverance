package GameCom.SystemComponents 
{
	/**
	 * ...
	 * @author ...
	 */
	public class MissionParameters {
		public var isStoryMission:Boolean = false;
		public var hasGoods:Boolean = false;
		
		public var StartNPC1:int = 0;
		public var StartNPC2:int = 0;
		public var EndNPC1:int = 0;
		public var EndNPC2:int = 0;
		public var Destination:int = 0;
		public var Origin:int = 0;
		
		public var ResourceType:int = -1;
		public var ResourceAmount:int = 0;
		
		public var ReputationRequired:int = 0;
		
		public var ReputationGain:int = -1;
		public var MonetaryGain:int = -1;
		
		public var AllowedSeconds:int = 0;
		public var TotalDistance:int = 0;
		
		public var StartText:String = "";
		public var PickupText:String = "";
		public var EndText:String = "";
		
		public var EnemyQuantity:int = 0;
	}

}