package GameCom.Helpers {
	import GameCom.Managers.GUIManager;
	import GameCom.SystemComponents.ReputationLevel;
	/**
	 * ...
	 * @author P. Fox
	 */
	
	public class ReputationHelper {
		
		private static var Levels:Vector.<ReputationLevel>;
		
		private static var CurrentLevel:int = 0;
		private static var CurrentReputation:int = 0;
		
		public static function Initialize(currentRep:int) : void {
			Levels = new Vector.<ReputationLevel>();
			
			Levels.push(new ReputationLevel("A Stranger", 	     -1));
			Levels.push(new ReputationLevel("", 			    500));
			Levels.push(new ReputationLevel("", 			   1000));
			Levels.push(new ReputationLevel("", 			   2500));
			Levels.push(new ReputationLevel("", 			   5000));
			Levels.push(new ReputationLevel("", 			  10000));
			Levels.push(new ReputationLevel("", 			  25000));
			Levels.push(new ReputationLevel("", 			  50000));
			Levels.push(new ReputationLevel("Relied On",	  80000));
			Levels.push(new ReputationLevel("", 			 125000));
			Levels.push(new ReputationLevel("", 			 175000));
			Levels.push(new ReputationLevel("Recognized",	 240000));
			Levels.push(new ReputationLevel("", 			 300000));
			Levels.push(new ReputationLevel("", 			 380000));
			Levels.push(new ReputationLevel("Popular",		 500000));
			Levels.push(new ReputationLevel("", 			 600000));
			Levels.push(new ReputationLevel("", 			 700000));
			Levels.push(new ReputationLevel("", 			 800000));
			Levels.push(new ReputationLevel("A Celebrity",	 900000));
			Levels.push(new ReputationLevel("", 			1000000));
			
			CurrentReputation = currentRep;
			CurrentLevel = 0;
			
			while (Levels[CurrentLevel + 1].ReputationRequired < CurrentReputation) {
				CurrentLevel++;
			}
		}
		
		/**
		 * Grants the player reputation.
		 * @param	newRep	How much rep the player gained
		 * @return	True if the player levelled up, false if they didn't.
		 */
		public static function GrantReputation(newRep:int) : Boolean {
			CurrentReputation += newRep;
			
			if (CurrentReputation > Levels[CurrentLevel + 1].ReputationRequired) {
				CurrentLevel++;
				
				GUIManager.I.UpdateCache();
				return true;
			}
			
			GUIManager.I.UpdateCache();
			return false;
		}
		
		public static function GetPercentageToNextLevel():Number {
			var cXP:int = Levels[CurrentLevel].ReputationRequired;
			var nXP:int = Levels[CurrentLevel + 1].ReputationRequired;
			
			return Number(CurrentReputation-cXP) / (nXP-cXP)
		}
		
		public static function GetCurrentLevel():int {
			return CurrentLevel + 1; //Makes it harder to crack :P
		}
		
	}

}