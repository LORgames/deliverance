package GameCom.Managers 
{
	/**
	 * ...
	 * @author P. Fox
	 */
	public class TriggerManager {
		
		public static function ReportTrigger(trigger:String) : void {
			trace(trigger);
			
			if (trigger == "place_Pickup") {
				MissionManager.GenerateNextMission();
			}
		}
		
	}

}