package GameCom.GameComponents 
{
	import Box2D.Dynamics.b2World;
	import flash.display.Graphics;
	import GameCom.Helpers.PeopleHelper;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.ResourceHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.PlacesManager;
	import GameCom.SystemComponents.MissionParameters;
	import GameCom.SystemComponents.ResourceInformation;
	import LORgames.Components.Tooltip;
	/**
	 * ...
	 * @author ...
	 */
	public class PickupPlace extends PlaceObject {
		
		public var MissionParams:MissionParameters = null;
		private var tooltipInfo:String;
		
		public function PickupPlace(type:int, posX:Number, posY:Number, angle:int, world:b2World, trigger:String, arrayIndex:int) {
			super(type, posX, posY, angle, world, trigger, arrayIndex);
		}
		
		override public function Draw(buffer:Graphics):void {
			super.Draw(buffer);
			
			if(tooltipInfo != "") {
				GUIManager.I.ShowTooltipAt(this.drawX + drawW / 2, this.drawY + drawH / 2, tooltipInfo);
			}
		}
		
		public function GenerateMission():void {
			if (ResourceHelper.HasSupportedResources(b_Resource)) {
				if (MissionParams == null) MissionParams = new MissionParameters();
				
				var ri:ResourceInformation = ResourceHelper.GetAvailableResource(b_Resource);
				
				if(ri != null) {
					MissionParams.ResourceType = ri.ID;
					MissionParams.ResourceAmount = ri.MinimumLoad + Math.floor(Math.random() * (ri.MaximumLoad - ri.MinimumLoad));
					
					var places:Vector.<PlaceObject> = PlacesManager.instance.DeliveryLocationsByResource[ri.ID];
					
					MissionParams.Origin = arrayIndex;
					MissionParams.Destination = PlacesManager.instance.DropatLocations.indexOf(places[Math.floor(places.length*Math.random())]);
					
					MissionParams.StartNPC1 = PeopleHelper.GetAvailableNPC(this.b_NPC);
					MissionParams.EndNPC1 = PeopleHelper.GetAvailableNPC(PlacesManager.instance.DropatLocations[MissionParams.Destination].b_NPC);
					
					var expGain:int = ri.ReputationGainPerItem * MissionParams.ResourceAmount;
					var monGain:int = ri.ValuePerItem * MissionParams.ResourceAmount;
					
					tooltipInfo = "Need to deliver " + MissionParams.ResourceAmount + ri.Message + ".\n\n";
					tooltipInfo += "Rewards:\n" + expGain + " Reputation (" + ReputationHelper.GetPercentageGain(expGain) + "%)\n";
					tooltipInfo += "$" + monGain + "\n\n";
					tooltipInfo += "Drive over and prease Enter to accept.";
					
					isActive = true;
					
					return;
				}
			}
			
			tooltipInfo = "";
			isActive = false;
		}
		
		public function Deactivate():void {
			tooltipInfo = "";
			isActive = false;
		}
		
	}

}