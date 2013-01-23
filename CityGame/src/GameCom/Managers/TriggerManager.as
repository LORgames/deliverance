package GameCom.Managers 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class TriggerManager {
		
		public static function ReportTrigger(trigger:String) : void {
			if (trigger == "place_Pickup") {
				MissionManager.GenerateNextMission();
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