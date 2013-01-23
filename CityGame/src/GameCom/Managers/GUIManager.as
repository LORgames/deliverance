package GameCom.Managers 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.Helpers.MoneyHelper;
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
		
		private var CurrentLevelText:TextField = new TextField();
		private var CurrentMoneyText:TextField = new TextField();
		private var CurrentSpeedText:TextField = new TextField();
		
		private var CurrentMissionText:TextField = new TextField();
		
		private var player:PlayerTruck;
		
		private var hasPopup:Boolean = false;
		private var popupText:TextField = new TextField();
		private var popupAlpha:Number = 0;
		private var popupFade:Boolean = false;
		
		public function GUIManager(player:PlayerTruck) {
			I = this;
			
			this.player = player;
			
			Overlay = new Sprite();
			Overlay.addChild(new Bitmap(ThemeManager.Get("GUI/Overlay.png")));
			this.addChild(Overlay);
			Overlay.x = 10;
			Overlay.y = 10;
			
			GPSArrow = SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("GUI/Directora.png"));
			this.addChild(GPSArrow);
			
			CurrentLevelText.selectable = false;
			CurrentLevelText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF);
			CurrentLevelText.x = 26;
			CurrentLevelText.y = 3;
			CurrentLevelText.autoSize = TextFieldAutoSize.CENTER
			CurrentLevelText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentLevelText);
			
			CurrentMoneyText.selectable = false;
			CurrentMoneyText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFF70);
			CurrentMoneyText.x = 75;
			CurrentMoneyText.y = 50;
			CurrentMoneyText.autoSize = TextFieldAutoSize.LEFT
			CurrentMoneyText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentMoneyText);
			
			CurrentSpeedText.selectable = false;
			CurrentSpeedText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF);
			CurrentSpeedText.x = 200;
			CurrentSpeedText.y = 3;
			CurrentSpeedText.autoSize = TextFieldAutoSize.LEFT
			CurrentSpeedText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentSpeedText);
			
			CurrentMissionText.selectable = false;
			CurrentMissionText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			CurrentMissionText.x = 400;
			CurrentMissionText.y = 3;
			CurrentMissionText.autoSize = TextFieldAutoSize.CENTER;
			CurrentMissionText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentMissionText);
			
			popupText.selectable = false;
			popupText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			popupText.x = 400;
			popupText.y = 3;
			popupText.autoSize = TextFieldAutoSize.CENTER;
			popupText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(popupText);
			
			UpdateCache();
		}
		
		public function Update() : void {
			GPSArrow.x = stage.stageWidth - 60;
			GPSArrow.y = stage.stageHeight - 60;
			
			CurrentSpeedText.text = Math.round(player.body.GetLinearVelocity().Length() * 3.6) + "km/h";
			
			if (MissionManager.CurrentDestination() != null) {
				GPSArrow.visible = true;
				GPSArrow.rotation = Math.atan2(MissionManager.CurrentDestination().y - player.y, MissionManager.CurrentDestination().x - player.x) / Math.PI * 180;
			} else {
				GPSArrow.visible = false;
			}
			
			if (popupAlpha > 0) {
				if (popupFade) {
					popupAlpha -= 0.02;
					if (popupAlpha <= 0) {
						popupText.text = "";
						hasPopup = false;
					}
				} else {
					popupFade = true;
				}
				popupText.alpha = popupAlpha;
				UpdateCache();
			}
		}
		
		public function SetMessage(msg:String) :void {
			if (stage) {
				CurrentMissionText.x = stage.stageWidth / 2;
				CurrentMissionText.y = stage.stageHeight - 50;
			}
			
			CurrentMissionText.text = msg;
		}
		
		public function Popup(msg:String) :void {
			if (!hasPopup) {
				if (stage) {
					popupText.x = stage.stageWidth - 120;
					popupText.y = stage.stageHeight - 50;
				}
				popupText.text = msg;
				hasPopup = true;
			}
			popupAlpha = 1.0;
			popupFade = false;
		}
		
		public function UpdateCache() : void {
			CurrentLevelText.text = ReputationHelper.GetCurrentLevel().toString();
			CurrentMoneyText.text = "$" + MoneyHelper.GetBalance();
			
			Overlay.graphics.clear();
			Overlay.graphics.beginFill(0x0000FF);
			Overlay.graphics.drawRect(88, 14, 88 * ReputationHelper.GetPercentageToNextLevel(), 4);
			Overlay.graphics.endFill();
			
			Overlay.graphics.beginFill(0xFF0000);
			Overlay.graphics.drawRect(80, 26, 94 * player.HealthPercent, 18);
			Overlay.graphics.endFill();
			
			if (hasPopup) {
				Overlay.graphics.beginFill(0x000000, popupAlpha);
				Overlay.graphics.drawRect(stage.stageWidth - 240, stage.stageHeight - 80, 240, 80);
				Overlay.graphics.endFill();
			}
		}
		
	}

}