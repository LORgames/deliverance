package GameCom.GameComponents 
{
	import Box2D.Dynamics.b2World;
	import flash.display.Graphics;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.ResourceHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.SystemComponents.MissionParameters;
	import GameCom.SystemComponents.ResourceInformation;
	import LORgames.Components.Tooltip;
	/**
	 * ...
	 * @author ...
	 */
	public class PickupPlace extends PlaceObject {
		
		public var MissionParams:MissionParameters = null;
		public var tooltip:Tooltip = new Tooltip("", Tooltip.UP, 25, 200, 0.75);
		
		public function PickupPlace(type:int, posX:Number, posY:Number, angle:int, world:b2World, trigger:String, arrayIndex:int) {
			super(type, posX, posY, angle, world, trigger, arrayIndex);
		}
		
		override public function Draw(buffer:Graphics):void {
			super.Draw(buffer);
			
			if (tooltip.parent != null) {
				tooltip.visible = true;
				tooltip.x = this.drawX - GUIManager.I.player.x + drawW/2 + GUIManager.I.stage.stageWidth/2;
				tooltip.y = this.drawY - GUIManager.I.player.y + drawH/2 + GUIManager.I.stage.stageHeight/2;
			} else {
				if (GUIManager.I != null) {
					GUIManager.I.addChild(tooltip);
				}
			}
		}
		
		public function GenerateMission():void {
			if (ResourceHelper.HasSupportedResources(b_Resource)) {
				if (MissionParams == null) MissionParams = new MissionParameters();
				
				var ri:ResourceInformation = ResourceHelper.GetAvailableResource(b_Resource);
				
				if(ri != null) {
					MissionParams.ResourceType = ri.ID;
					MissionParams.ResourceAmount = ri.MinimumLoad + Math.floor(Math.random() * (ri.MaximumLoad - ri.MinimumLoad));
					
					MissionParams.Origin = arrayIndex;
					MissionParams.Destination = 0;
					
					var expGain:int = ri.ReputationGainPerItem * MissionParams.ResourceAmount;
					var monGain:int = ri.ValuePerItem * MissionParams.ResourceAmount;
					
					tooltip.SetText("Need to deliver " + MissionParams.ResourceAmount + ri.Message + ".\n\nRewards:\n" + expGain + " Reputation ("+ReputationHelper.GetPercentageGain(expGain)+"%)\n$" + monGain);
					
					isActive = true;
					
					return;
				}
			}
			
			tooltip.visible = false;
			isActive = false;
		}
		
		public function Deactivate():void {
			tooltip.visible = false;
			isActive = false;
		}
		
	}

}