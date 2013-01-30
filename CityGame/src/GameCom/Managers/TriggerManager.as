package GameCom.Managers 
{
	import flash.display.Bitmap;
	import GameCom.GameComponents.PickupPlace;
	import LORgames.Engine.Keys;
	import flash.ui.Keyboard;
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
				//TODO: Actually have a shop class perhaps? You know, so its interactive
				GUIManager.I.addChild(new Bitmap(ThemeManager.Get("GUI/Shop.png")));
			}else {
				trace(trigger);
			}
		}
	}
}