package GameCom.Managers 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.Helpers.MathHelper;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.States.StoreOverlay;
	/**
	 * ...
	 * @author Paul
	 */
	public class GUIManager extends Sprite {
		
		public static var I:GUIManager;
		
		private var GPSBase:Sprite = new Sprite();
		private var GPSArrow:Sprite;
		private var GPSDistance:TextField = new TextField();
		
		private var Overlay:Sprite;
		
		private var CurrentLevelText:TextField = new TextField();
		private var CurrentMoneyText:TextField = new TextField();
		private var CurrentSpeedText:TextField = new TextField();
		
		public var player:PlayerTruck;
		
		private var hasPopup:Boolean = false;
		private var popupText:TextField = new TextField();
		private var popupAlpha:Number = 0;
		private var popupFade:Boolean = false;
		
		private var Pause:Function;
		private var store:StoreOverlay;
		
		public function GUIManager(player:PlayerTruck, pauseLoopback:Function) {
			I = this;
			
			this.player = player;
			
			Overlay = new Sprite();
			Overlay.addChild(new Bitmap(ThemeManager.Get("GUI/Overlay.png")));
			this.addChild(Overlay);
			Overlay.x = 10;
			Overlay.y = 10;
			
			GPSBase.addChild(new Bitmap(ThemeManager.Get("GUI/GPS base.png")));
			this.addChild(GPSBase);
			
			GPSArrow = SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("GUI/GPS arrow.png"));
			GPSBase.addChild(GPSArrow);
			
			GPSArrow.x = 82;
			GPSArrow.y = 39;
			
			GPSDistance.selectable = false;
			GPSDistance.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF);
			GPSDistance.autoSize = TextFieldAutoSize.CENTER;
			GPSDistance.x = 69;
			GPSDistance.y = 76;
			GPSDistance.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			GPSBase.addChild(GPSDistance);
			
			CurrentLevelText.selectable = false;
			CurrentLevelText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF);
			CurrentLevelText.x = 26;
			CurrentLevelText.y = 3;
			CurrentLevelText.autoSize = TextFieldAutoSize.CENTER;
			CurrentLevelText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentLevelText);
			
			CurrentMoneyText.selectable = false;
			CurrentMoneyText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFF70);
			CurrentMoneyText.x = 75;
			CurrentMoneyText.y = 50;
			CurrentMoneyText.autoSize = TextFieldAutoSize.LEFT;
			CurrentMoneyText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentMoneyText);
			
			CurrentSpeedText.selectable = false;
			CurrentSpeedText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF);
			CurrentSpeedText.x = 200;
			CurrentSpeedText.y = 3;
			CurrentSpeedText.autoSize = TextFieldAutoSize.LEFT;
			CurrentSpeedText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentSpeedText);
			
			popupText.selectable = false;
			popupText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			popupText.x = 400;
			popupText.y = 3;
			popupText.autoSize = TextFieldAutoSize.CENTER;
			popupText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(popupText);
			
			UpdateCache();
			
			this.Pause = pauseLoopback;
			store = new StoreOverlay();
		}
		
		public function Update() : void {
			GPSBase.x = stage.stageWidth - (GPSBase.width + 5);
			GPSBase.y = stage.stageHeight - (GPSBase.height + 5);
			
			CurrentSpeedText.text = Math.round(player.body.GetLinearVelocity().Length() * 3.6) + "km/h";
			
			if (MissionManager.CurrentDestination() != null) {
				GPSArrow.visible = true;
				GPSArrow.rotation = Math.atan2(MissionManager.CurrentDestination().y - player.y, MissionManager.CurrentDestination().x - player.x) / Math.PI * 180;
				GPSDistance.text = Math.floor(Math.sqrt(MathHelper.DistanceSquared(MissionManager.CurrentDestination(), new Point(player.x, player.y)))/Global.PHYSICS_SCALE) + "m";
			} else {
				GPSArrow.visible = false;
				GPSDistance.text = "";
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
				
				if (hasPopup) {
					Overlay.graphics.clear();
					
					var m:Matrix = new Matrix();
					m.createBox(1, 1, 0, (stage.stageWidth - 665) / 2, stage.stageHeight - 240);
					
					Overlay.graphics.beginBitmapFill(ThemeManager.Get("GUI/Message board.png"), m, false);
					Overlay.graphics.drawRect((stage.stageWidth - 665) / 2, stage.stageHeight - 240, 665, 240);
					Overlay.graphics.endFill();
				}
			}
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
		}
		
		public function ActivateStore():void {
			this.addChild(store);
			
			Pause.call();
		}
		
		public function DeactivateStore():void {
			this.removeChild(store);
			
			Pause.call();
			
			player.FixUpgradeValues();
			player.Respawn();
		}
		
	}

}