package GameCom.Helpers {
	import GameCom.Managers.GUIManager;
	import GameCom.SystemComponents.ReputationLevel;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author P. Fox
	 */
	
	public class ReputationHelper {
		
		private static var Levels:Vector.<ReputationLevel>;
		
		private static var CurrentLevel:int = 0;
		private static var CurrentReputation:int = 0;
		
		public static function Initialize() : void {
			Levels = new Vector.<ReputationLevel>();
			
			Levels.push(new ReputationLevel("A Stranger", 	      0));
			Levels.push(new ReputationLevel("That Guy", 	    500));
			Levels.push(new ReputationLevel("",				   1000));
			Levels.push(new ReputationLevel("", 			   2500));
			Levels.push(new ReputationLevel("", 			   5000));
			Levels.push(new ReputationLevel("",  			  10000));
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
			Levels.push(new ReputationLevel("Godlike",		1000000));
			
			CurrentReputation = Storage.GetAsInt("Reputation");
			CurrentLevel = 0;
			
			while (CurrentLevel < 19 && Levels[CurrentLevel + 1].ReputationRequired < CurrentReputation) {
				CurrentLevel++;
			}
		}
		
		/**
		 * Grants the player reputation.
		 * @param	newRep	How much rep the player gained
		 */
		public static function GrantReputation(newRep:int) : void {
			CurrentReputation += newRep;
			
			Storage.Set("Reputation", CurrentReputation);
			
			while (CurrentLevel < 19 && CurrentReputation >= Levels[CurrentLevel + 1].ReputationRequired) {
				CurrentLevel++;
				ResourceHelper.UpdateAvailableResources();
				
				if (CurrentLevel == 4) {
					GUIManager.I.player.EquipWeapon("MachineGun");
				}
			}
		}
		
		public static function GetCurrentReputation():int {
			return CurrentReputation;
		}
		
		public static function GetPercentageToNextLevel():Number {
			if (CurrentLevel == 19) return 1;
			
			var cXP:int = Levels[CurrentLevel].ReputationRequired;
			var nXP:int = Levels[CurrentLevel + 1].ReputationRequired;
			
			return Number(CurrentReputation - cXP) / (nXP - cXP);
		}
		
		public static function GetPercentageGain(exp:int):String {
			var cXP:int = Levels[CurrentLevel].ReputationRequired;
			var nXP:int = Levels[CurrentLevel + 1].ReputationRequired;
			
			return Number(100*Number(exp) / (nXP - cXP)).toFixed(2);
		}
		
		public static function GetAcceptableLevelPercent():int {
			var cXP:int = Levels[CurrentLevel].ReputationRequired;
			var nXP:int = Levels[CurrentLevel + 1].ReputationRequired;
			
			var x:Number = Math.random() / 5 + 0.1;
			
			return ((nXP - cXP) * x);
		}
		
		public static function GetCurrentLevel():int {
			return CurrentLevel + 1; //Makes it harder to crack :P
		}
		
	}

}