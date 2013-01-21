package GameCom.Managers 
{
	import flash.display.Sprite;
	import GameCom.Helpers.SpriteHelper;
	/**
	 * ...
	 * @author Paul
	 */
	public class GUIManager extends Sprite {
		
		private var GPSArrow:Sprite;
		private var Overlay:Sprite;
		
		private var player:Sprite;
		
		public function GUIManager(player:Sprite) {
			this.player = player;
			
			Overlay = SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("GUI/TopUI.png"));
			this.addChild(Overlay);
			Overlay.x = 100;
			Overlay.y = 40;
			
			GPSArrow = SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("GUI/Arrow.png"));
			this.addChild(GPSArrow);
		}
		
		public function Update() : void {
			GPSArrow.x = stage.stageWidth - 60;
			GPSArrow.y = stage.stageHeight - 60;
			
			if (MissionManager.CurrentDestination() != null) {
				GPSArrow.rotation = Math.atan2(MissionManager.CurrentDestination().y - player.y, MissionManager.CurrentDestination().x - player.x) / Math.PI * 180;
			} else {
				GPSArrow.rotation += 30;
			}
		}
		
	}

}