package GameCom.Managers 
{
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
			} else {
				trace(trigger);
			}
		}
	}
}