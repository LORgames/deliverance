package GameCom.Managers {
	import GameCom.GameComponents.PlaceObject;
	import GameCom.States.GameScreen;
	
	/**
	 * ...
	 * @author P. Fox
	 */
	public class MissionManager {
		private static var DeliveryDestination:int = 0;
		
		private static var DeliveryResourcesType:int = 0;
		private static var DeliveryResourcesCount:int = 0;
		
		private static var DeliveryType:int = 0;
		
		public static function GenerateNextMission() : void {
			var po:PlaceObject = (PlacesManager.instance.DropatLocations[int(PlacesManager.instance.DropatLocations.length * Math.random())] as PlaceObject);
			
			DeliveryDestination = po.index;
			po.isActive = true;
			
			for (var i:int = 0; i < PlacesManager.instance.PickupLocations.length; i++) {
				(PlacesManager.instance.PickupLocations[i] as PlaceObject).isActive = false;
			}
		}
		
		public static function CheckMissionParameters() : Boolean {
			return false;
		}
		
	}

}