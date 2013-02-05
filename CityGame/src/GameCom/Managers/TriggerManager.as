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
				
				// popup notification of mission
				GUIManager.I.Popup("Press Enter to accept mission!");
				if (Keys.isKeyDown(Keyboard.ENTER)) {
					MissionManager.GenerateFromPickup(obj as PickupPlace);
				}
			} else if (trigger == "place_Deliver") {
				MissionManager.CheckMissionParameters();
			} else if (trigger == "place_Weapons") {
				GUIManager.I.ActivateStore();
			} else if (trigger == "place_Collectable") { 
				var id:int = PlacesManager.instance.CollectableLocations.indexOf(obj);
				(obj as PlaceObject).isActive = false;
				
				Storage.Set("Collectable_" + id, true);
				
				GUIManager.I.SetMessage("Found collectable " + (id+1) + " of " + PlacesManager.instance.CollectableLocations.length);
			}
		}
	}
}