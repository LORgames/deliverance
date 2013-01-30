package GameCom.GameComponents 
{
	import Box2D.Dynamics.b2World;
	import flash.display.Graphics;
	import GameCom.Helpers.ResourceHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.SystemComponents.MissionParameters;
	import LORgames.Components.Tooltip;
	/**
	 * ...
	 * @author ...
	 */
	public class PickupPlace extends PlaceObject {
		
		public var MissionParams:MissionParameters = null;
		public var tooltip:Tooltip = new Tooltip();
		
		public function PickupPlace(type:int, posX:Number, posY:Number, angle:int, world:b2World, trigger:String) {
			super(type, posX, posY, angle, world, trigger);
		}
		
		override public function Draw(buffer:Graphics):void {
			super.Draw(buffer);
			
			if (tooltip.parent != null) {
				tooltip.x = this.drawX - GUIManager.I.player.x + drawW/2 + GUIManager.I.stage.stageWidth/2;
				tooltip.y = this.drawY - GUIManager.I.player.y + drawH/2 + GUIManager.I.stage.stageHeight/2;
			} else {
				if (GUIManager.I != null) {
					GUIManager.I.addChild(tooltip);
				}
			}
		}
		
		public function GenerateMission():void {
			ResourceHelper.GetRandomResourceFromSupportedResources(b_Resource);
			
			tooltip.SetText("TEST");
		}
		
	}

}