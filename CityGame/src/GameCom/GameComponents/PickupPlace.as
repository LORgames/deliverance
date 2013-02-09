package GameCom.GameComponents 
{
	import Box2D.Dynamics.b2World;
	import flash.display.Graphics;
	import flash.geom.Point;
	import GameCom.Helpers.MathHelper;
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
		
		private const MINIMUM_DISTANCE:int = 500; // minimum distance between origin and destination
		
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
				
				if (ri != null) {
					MissionParams.ResourceType = ri.ID;
					
					var minAmount:int = ri.MinimumLoad;
					
					if (ReputationHelper.GetAcceptableLevelPercent() / ri.ReputationGainPerItem > minAmount) {
						minAmount = ReputationHelper.GetAcceptableLevelPercent() / ri.ReputationGainPerItem;
					}
					
					if (minAmount > ri.MaximumLoad) {
						MissionParams.ResourceAmount = minAmount;
					}else {
						MissionParams.ResourceAmount = minAmount + Math.floor(Math.random() * (ri.MaximumLoad - minAmount));
					}
					
					var places:Vector.<PlaceObject> = PlacesManager.instance.DeliveryLocationsByResource[ri.ID];
					
					MissionParams.Origin = arrayIndex;
					
					var deliverDistance:Number;
					var attempts:int = 0;
					
					while (attempts < 5) {
						var destinationPlaceObject:PlaceObject = places[Math.floor(places.length * Math.random())];
						MissionParams.Destination = PlacesManager.instance.DropatLocations.indexOf(destinationPlaceObject);
						
						deliverDistance = MathHelper.Distance(new Point(destinationPlaceObject.drawX, destinationPlaceObject.drawY), new Point(this.drawX, this.drawY));
						
						if (deliverDistance > MINIMUM_DISTANCE) {
							break;
						}
						
						attempts++;
					}
					
					MissionParams.StartNPC1 = PeopleHelper.GetAvailableNPC(this.b_NPC);
					MissionParams.EndNPC1 = PeopleHelper.GetAvailableNPC(PlacesManager.instance.DropatLocations[MissionParams.Destination].b_NPC);
					
					MissionParams.TotalDistance = deliverDistance;
					
					var expGain:int = ri.ReputationGainPerItem * MissionParams.ResourceAmount;
					var monGain:int = ri.ValuePerItem * MissionParams.ResourceAmount;
					
					tooltipInfo = "Need to deliver " + MissionParams.ResourceAmount + ri.Message + " to the " + PeopleHelper.Names[MissionParams.EndNPC1];
					tooltipInfo += " <font color='#28D32D'>" + int(deliverDistance / Global.PHYSICS_SCALE) + "m</font> away.\n\n";
					tooltipInfo += "Rewards:\n<font color='#27AEFF'>" + expGain + " Reputation (" + ReputationHelper.GetPercentageGain(expGain) + "%)</font>\n";
					tooltipInfo += "<font color='#FFAA00'>$" + monGain + "</font>\n\n";
					tooltipInfo += "Drive into pickup zone and press Spacebar to accept.";
					
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