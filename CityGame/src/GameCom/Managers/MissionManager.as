package GameCom.Managers {
	import flash.geom.Point;
	import flash.utils.getTimer;
	import GameCom.GameComponents.PickupPlace;
	import GameCom.GameComponents.PlaceObject;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.ResourceHelper;
	import GameCom.States.GameScreen;
	import GameCom.SystemComponents.MissionParameters;
	import GameCom.SystemComponents.ResourceInformation;
	
	/**
	 * ...
	 * @author P. Fox
	 */
	public class MissionManager {
		private static var DeliveryDestination:PlaceObject;
		
		private static var DeliveryResourcesType:int = 0;
		private static var DeliveryResourcesCount:int = 0;
		
		private static var DeliveryType:int = 0;
		private static var DeliveryStartTime:int = 0;
		
		public static function GenerateAllMissions() : void {
			for (var i:int = 0; i < PlacesManager.instance.PickupLocations.length; i++) {
				PlacesManager.instance.PickupLocations[i].GenerateMission();
			}
		}
		
		public static function GenerateNextMission() : void {
			DeliveryDestination = (PlacesManager.instance.DropatLocations[int(PlacesManager.instance.DropatLocations.length * Math.random())] as PlaceObject);
			DeliveryDestination.isActive = true;
			DeliveryStartTime = getTimer();
			
			ResourceHelper.GenerateRandomMission();
			
			for (var i:int = 0; i < PlacesManager.instance.PickupLocations.length; i++) {
				PlacesManager.instance.PickupLocations[i].Deactivate();
			}
			
			GUIManager.I.UpdateCache();
			GUIManager.I.SetMessage("Please deliver " + DeliveryResourcesCount + ResourceHelper.GetResouce(DeliveryResourcesType).Message + " to the destination marked ASAP!");
		}
		
		public static function SetNextMission(params:MissionParameters) : void {
			var resourceIndex:int = params.ResourceType;
			var amount:int = params.ResourceAmount;
			var pickup:int = params.Origin;
			var dropOff:int = params.Destination;
			var npc:int = params.NPC;
			
			DeliveryDestination = (PlacesManager.instance.DropatLocations[dropOff] as PlaceObject);
			DeliveryDestination.isActive = true;
			DeliveryStartTime = getTimer();
			
			MissionManager.SetDeliveryResources(resourceIndex, amount);
			
			for (var i:int = 0; i < PlacesManager.instance.PickupLocations.length; i++) {
				PlacesManager.instance.PickupLocations[i].Deactivate();
			}
			
			GUIManager.I.UpdateCache();
			GUIManager.I.SetMessage("Please deliver " + DeliveryResourcesCount + ResourceHelper.GetResouce(DeliveryResourcesType).Message + " to the destination marked ASAP!");
		}
		
		public static function GenerateFromPickup(place:PickupPlace):void {
			SetNextMission(place.MissionParams);
		}
		
		public static function SetDeliveryResources(type:int, value:int):void {
			DeliveryResourcesType = type;
			DeliveryResourcesCount = value;
		}
		
		public static function CheckMissionParameters() : Boolean {
			if (getTimer() - DeliveryStartTime > 0) {
				DeliveryDestination.isActive = false;
				
				DeliveryDestination = null;
				
				ReputationHelper.GrantReputation(DeliveryResourcesCount * ResourceHelper.GetResouce(DeliveryResourcesType).ReputationGainPerItem);
				MoneyHelper.Credit(DeliveryResourcesCount * ResourceHelper.GetResouce(DeliveryResourcesType).ValuePerItem);
				
				GenerateAllMissions();
				
				GUIManager.I.UpdateCache();
				GUIManager.I.SetMessage("");
				
				//TODO: Do some varible checking things...
				//Mission is complete
				return true;
			} else {
				//Mission not complete
				return false;
			}
		}
		
		public static function CurrentDestination() : Point {
			if (DeliveryDestination != null) {
				return new Point(DeliveryDestination.drawX, DeliveryDestination.drawY);
			}
			
			return null;
		}
	}

}