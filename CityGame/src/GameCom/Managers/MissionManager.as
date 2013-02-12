package GameCom.Managers {
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import GameCom.GameComponents.PickupPlace;
	import GameCom.GameComponents.PlaceObject;
	import GameCom.Helpers.MathHelper;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.PeopleHelper;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.ResourceHelper;
	import GameCom.States.EndGame;
	import GameCom.States.GameScreen;
	import GameCom.SystemComponents.MissionParameters;
	import GameCom.SystemComponents.ResourceInformation;
	import GameCom.SystemComponents.Stat;
	import GameCom.SystemMain;
	import LORgames.Engine.Stats;
	import LORgames.Engine.Storage;
	
	/**
	 * ...
	 * @author P. Fox
	 */
	public class MissionManager {
		private static var _CurrentDestination:PlaceObject;
		private static var CurrentMission:MissionParameters;
		
		private static var DeliveryStartTime:int = 0;
		
		private static var missionArray:Vector.<MissionParameters> = new Vector.<MissionParameters>();
		private static var nextMissionRepRequired:int = 0;
		private static var highestMissionCompleted:int = -1;
			
		public static function Initialize() : Boolean {
			// load in nodes
			var missionfile:ByteArray = ThemeManager.Get("story.bin");
			missionfile.position = 0;
			
			var numstories:int = missionfile.readInt();
			missionArray = new Vector.<MissionParameters>();
			
			for (var i:int = 0; i < numstories; i++) {
				var temp:MissionParameters = new MissionParameters();
				
				temp.isStoryMission = true;
				
				temp.Origin = missionfile.readInt();
				temp.Destination = missionfile.readInt();
				
				temp.StartNPC1 = missionfile.readShort();
				temp.StartNPC2 = missionfile.readShort();
				temp.EndNPC1 = missionfile.readShort();
				temp.EndNPC2 = missionfile.readShort();
				
				temp.ReputationRequired = missionfile.readInt();
				
				temp.ReputationGain = missionfile.readInt();
				temp.MonetaryGain = missionfile.readInt();
				
				var startTextLength:int = missionfile.readShort();
				temp.StartText = missionfile.readMultiByte(startTextLength, "iso-8859-1");
				
				var pickupTextLength:int = missionfile.readShort();
				temp.PickupText = missionfile.readMultiByte(pickupTextLength, "iso-8859-1");
				
				var endTextLength:int = missionfile.readShort();
				temp.EndText = missionfile.readMultiByte(endTextLength, "iso-8859-1");
				
				temp.EnemyQuantity = missionfile.readShort();
				
				var f:PlaceObject = PlacesManager.instance.PickupLocations[temp.Origin];
				var t:PlaceObject = PlacesManager.instance.DropatLocations[temp.Destination];
				
				temp.TotalDistance = MathHelper.Distance(f.position, t.position);
				
				missionArray.push(temp);
			}
			
			highestMissionCompleted = Storage.GetAsInt("HighestMissionCompleted", -1);
			return UpdateRepRequiredForNextMission();
		}
		
		private static function UpdateRepRequiredForNextMission():Boolean {
			if (highestMissionCompleted == missionArray.length) {
				nextMissionRepRequired = int.MAX_VALUE; //LOTS OF REP NEEDED
			} else {
				if(highestMissionCompleted+1 < missionArray.length) {
					nextMissionRepRequired = missionArray[highestMissionCompleted + 1].ReputationRequired;
				} else {
					SystemMain.instance.StateTo(new EndGame());
					return false;
				}
			}
			
			return true;
		}
		
		public static function GenerateAllMissions() : void {
			if (ReputationHelper.GetCurrentReputation() >= nextMissionRepRequired) {
				SetNextMission(missionArray[highestMissionCompleted + 1]);
			} else {
				for (var i:int = 0; i < PlacesManager.instance.PickupLocations.length; i++) {
					PlacesManager.instance.PickupLocations[i].GenerateMission();
				}
			}
		}
		
		public static function SetNextMission(params:MissionParameters) : void {
			//Deactivate all places
			for (var i:int = 0; i < PlacesManager.instance.PickupLocations.length; i++) {
				PlacesManager.instance.PickupLocations[i].Deactivate();
			}
			
			CurrentMission = params;
			DeliveryStartTime = getTimer();
			
			if (!params.isStoryMission) {
				GUIManager.I.Popup(PeopleHelper.PickupMessages[CurrentMission.StartNPC1], CurrentMission.StartNPC1, CurrentMission.StartNPC2);
				
				CurrentMission.hasGoods = true;
				
				_CurrentDestination = (PlacesManager.instance.DropatLocations[params.Destination] as PlaceObject);
				
				CurrentMission.ReputationGain = CurrentMission.ResourceAmount * ResourceHelper.GetResouce(CurrentMission.ResourceType).ReputationGainPerItem;
				CurrentMission.MonetaryGain = CurrentMission.ResourceAmount * ResourceHelper.GetResouce(CurrentMission.ResourceType).ValuePerItem;
			} else {
				_CurrentDestination = (PlacesManager.instance.PickupLocations[params.Origin] as PlaceObject);
				GUIManager.I.Popup(CurrentMission.StartText, CurrentMission.StartNPC1);
			}
			
			_CurrentDestination.isActive = true;
				
			GUIManager.I.UpdateCache();
		}
		
		public static function GenerateFromPickup(place:PickupPlace):void {
			SetNextMission(place.MissionParams);
		}
		
		public static function CheckMissionParameters(object:PlaceObject):void {
			if (_CurrentDestination is PickupPlace && !CurrentMission.hasGoods) {
				_CurrentDestination.isActive = false;
				
				if (CurrentMission.isStoryMission) {
					GUIManager.I.Popup(CurrentMission.PickupText, CurrentMission.StartNPC1, CurrentMission.StartNPC2);
				}
				
				_CurrentDestination = PlacesManager.instance.DropatLocations[CurrentMission.Destination];
				_CurrentDestination.isActive = true;
				
				CurrentMission.hasGoods = true;
			} else {
				_CurrentDestination.isActive = false;
				_CurrentDestination = null;
				
				Stats.AddOne(Stat.NUMBER_OF_DELIVERIES);
				
				ReputationHelper.GrantReputation(CurrentMission.ReputationGain);
				MoneyHelper.Credit(CurrentMission.MonetaryGain);
				
				if (CurrentMission.isStoryMission) {
					GUIManager.I.Popup(CurrentMission.EndText, CurrentMission.EndNPC1, CurrentMission.EndNPC2);
					highestMissionCompleted++;
					Storage.Set("HighestMissionCompleted", highestMissionCompleted);
					UpdateRepRequiredForNextMission();
					
					Stats.SetHighestInt(Stat.HIGHEST_STORY_MISSION, highestMissionCompleted);
				} else {
					Stats.SetHighestInt(Stat.LONGEST_DELIVERY, CurrentMission.TotalDistance);
					Stats.SetLowestInt(Stat.SHORTEST_DELIVERY, CurrentMission.TotalDistance);
					
					Stats.AddOne(Stat.TOTAL_DELIVERY_FROM_PREFIX + CurrentMission.StartNPC1);
					Stats.AddOne(Stat.TOTAL_DELIVERY_TO_PREFIX + CurrentMission.EndNPC1);
					
					GUIManager.I.Popup(PeopleHelper.DropOffMessages[CurrentMission.EndNPC1], CurrentMission.EndNPC1, CurrentMission.EndNPC2);
				}
				
				Stats.AddValue(Stat.TOTAL_DELIVERY_DISTANCE, CurrentMission.TotalDistance);
				
				CurrentMission = null;
				GUIManager.I.UpdateCache();
				
				GenerateAllMissions();
			}
		}
		
		public static function IsInMission():Boolean {
			return (CurrentMission != null);
		}
		
		public static function CurrentDestination() : Point {
			if (_CurrentDestination != null) {
				return _CurrentDestination.position;
			}
			
			return null;
		}
		
		public static function CurrentAllowedEnemies():int {
			if (CurrentMission != null) {
				return CurrentMission.EnemyQuantity;
			} else {
				if (ReputationHelper.GetCurrentLevel() < 5) {
					return 0;
				} else if (ReputationHelper.GetCurrentLevel() < 10) {
					return 1;
				} else if (ReputationHelper.GetCurrentLevel() < 15) {
					return 2;
				} else {
					return 3;
				}
			}
		}
		
		public static function CancelMission():Boolean {
			if (!IsInMission() || CurrentMission.isStoryMission) return false;
			
			_CurrentDestination.isActive = false;
			_CurrentDestination = null;
			
			CurrentMission = null;
			GUIManager.I.UpdateCache();
			
			GenerateAllMissions();
			
			return true;
		}
	}

}