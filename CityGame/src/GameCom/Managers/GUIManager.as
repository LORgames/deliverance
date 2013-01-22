package GameCom.Managers 
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.SpriteHelper;
	/**
	 * ...
	 * @author Paul
	 */
	public class GUIManager extends Sprite {
		
		public static var I:GUIManager;
		
		private var GPSArrow:Sprite;
		private var Overlay:Sprite;
		private var currentLevel:TextField = new TextField();
		
		private var player:Sprite;
		
		public function GUIManager(player:Sprite) {
			I = this;
			
			this.player = player;
			
			Overlay = SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("GUI/Overlay.png"));
			this.addChild(Overlay);
			Overlay.x = 100;
			Overlay.y = 40;
			
			GPSArrow = SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("GUI/Directora.png"));
			this.addChild(GPSArrow);
			
			currentLevel.selectable = false;
			currentLevel.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF);
			currentLevel.x = -65;
			currentLevel.y = -35;
			currentLevel.autoSize = TextFieldAutoSize.CENTER
			currentLevel.filters = new Array(new GlowFilter(0, 1, 2, 2, 2, 3));
			Overlay.addChild(currentLevel);
			
			//currentLevel.defaultTextFormat = new TextFormat("Verdana", 18, 0xFFFFFF, true);
			
			UpdateCache();
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
		
		public function UpdateCache() : void {
			currentLevel.text = ReputationHelper.GetCurrentLevel().toString();
			
			Overlay.graphics.clear();
			Overlay.graphics.beginFill(0x0000FF);
			Overlay.graphics.drawRect(-Overlay.width/2 + 88, -Overlay.height/2 + 14, 88 * ReputationHelper.GetPercentageToNextLevel(), 4);
			Overlay.graphics.endFill();
			
			Overlay.graphics.beginFill(0xFF0000);
			Overlay.graphics.drawRect(-Overlay.width/2 + 80, -Overlay.height/2 + 26, 94 * (player as PlayerTruck).HealthPercent, 18);
			Overlay.graphics.endFill();
		}
		
	}

}