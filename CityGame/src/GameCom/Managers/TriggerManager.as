package GameCom.Managers 
{
	import flash.display.Bitmap;
	import GameCom.GameComponents.PickupPlace;
	import GameCom.GameComponents.PlaceObject;
	import LORgames.Engine.Keys;
	import flash.ui.Keyboard;
	import LORgames.Engine.MessageBox;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class TriggerManager {
		
		public static function ReportTrigger(trigger:String, obj:* = null) : void {
			if (trigger == "place_Pickup") {
				//TODO: See if I'm on a mission to collect something?
				if (MissionManager.IsInMission()) {
					MissionManager.CheckMissionParameters(obj as PlaceObject);
				} else {
					if (Keys.isKeyDown(Keyboard.SPACE)) {
						MissionManager.GenerateFromPickup(obj as PickupPlace);
					}
				}
			} else if (trigger == "place_Deliver") {
				MissionManager.CheckMissionParameters(obj as PlaceObject);
			} else if (trigger == "place_Weapons") {
				GUIManager.I.ActivateStore();
			} else if (trigger == "place_Collectable") { 
				var id:int = PlacesManager.instance.CollectableLocations.indexOf(obj);
				(obj as PlaceObject).isActive = false;
				
				Storage.Set("Collectable_" + id, true);
				Storage.Set("TotalCollectablesFound", 1 + Storage.GetAsInt("TotalCollectablesFound"));
				
				if(Storage.GetAsInt("TotalCollectablesFound") > 50) {
					GUIManager.I.Popup(Storage.GetAsInt("TotalCollectablesFound") + " of " + PlacesManager.instance.CollectableLocations.length + " laser components found.");
				} else {
					GUIManager.I.Popup("You found them all! Your laser is ready to collect at any garage!");
				}
			}
		}
	}
}