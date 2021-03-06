package GameCom.Managers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.MathHelper;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.States.MapOverlay;
	import GameCom.States.StoreOverlay;
	import GameCom.SystemComponents.PopupInfo;
	import LORgames.Components.Button;
	import LORgames.Components.Tooltip;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Mousey;
	/**
	 * ...
	 * @author Paul
	 */
	public class GUIManager extends Sprite {
		
		public static var I:GUIManager;
		
		private static const MINIMAP_SIZE_R:int = 75;
		
		private var GPSArrow:Sprite;
		private var GPSDistance:TextField = new TextField();
		
		private var Overlay:Sprite;
		private var PopupSprite:Sprite = new Sprite();
		
		private var MinimapSprite:Sprite = new Sprite();
		private var MinimapOverlay:Bitmap = new Bitmap(ThemeManager.Get("GUI/Minimap Border.png"));
		private var MinimapOverlaySoundOn:Bitmap = new Bitmap(ThemeManager.Get("GUI/Minimap Sound On.png"));
		private var MuteButton:Button = new Button("MUTE", 30, 30);
		
		private var CurrentLevelText:TextField = new TextField();
		private var CurrentMoneyText:TextField = new TextField();
		private var CurrentSpeedText:TextField = new TextField();
		
		public var player:PlayerTruck;
		
		private var popupMessages:Vector.<PopupInfo> = new Vector.<PopupInfo>();
		private var popupCloseMessage:TextField = new TextField();
		private var popupText:TextField = new TextField();
		private var popupAlpha:Number = 0;
		private var popupFadeIn:Boolean = false;
		private var popupFadeOut:Boolean = false;
		
		private var tooltips:Vector.<Tooltip> = new Vector.<Tooltip>();
		private var currentFrameTooltipIndex:int = 0;
		
		private var Pause:Function;
		private var MockUpdateWorld:Function;
		
		private var store:StoreOverlay;
		private var map:MapOverlay;
		
		private var hasOverlay:Boolean = false;
		
		public function GUIManager(player:PlayerTruck, pauseLoopback:Function, mockupdate:Function) {
			I = this;
			
			this.player = player;
			
			Overlay = new Sprite();
			Overlay.addChild(new Bitmap(ThemeManager.Get("GUI/Overlay.png")));
			this.addChild(Overlay);
			Overlay.x = 10;
			Overlay.y = 10;
			
			Overlay.addChild(MinimapSprite);
			Overlay.addChild(MinimapOverlay);
			Overlay.addChild(MinimapOverlaySoundOn);
			
			GPSArrow = ThemeManager.Get("SWFs/Arrow.swf");
			this.addChild(GPSArrow);
			
			GPSDistance.selectable = false;
			GPSDistance.defaultTextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
			GPSDistance.autoSize = TextFieldAutoSize.CENTER;
			GPSDistance.x = GPSArrow.x;
			GPSDistance.y = GPSArrow.y;
			if(Global.HIGH_QUALITY) GPSDistance.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			this.addChild(GPSDistance);
			
			CurrentLevelText.selectable = false;
			CurrentLevelText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF);
			CurrentLevelText.x = 26;
			CurrentLevelText.y = 3;
			CurrentLevelText.autoSize = TextFieldAutoSize.CENTER;
			if(Global.HIGH_QUALITY) CurrentLevelText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentLevelText);
			
			CurrentMoneyText.selectable = false;
			CurrentMoneyText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFF70);
			CurrentMoneyText.x = 75;
			CurrentMoneyText.y = 50;
			CurrentMoneyText.autoSize = TextFieldAutoSize.LEFT;
			if(Global.HIGH_QUALITY) CurrentMoneyText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentMoneyText);
			
			CurrentSpeedText.selectable = false;
			CurrentSpeedText.defaultTextFormat = new TextFormat("Verdana", 15, 0xFFFFFF);
			CurrentSpeedText.x = 140;
			CurrentSpeedText.y = -6;
			CurrentSpeedText.autoSize = TextFieldAutoSize.LEFT;
			if(Global.HIGH_QUALITY) CurrentSpeedText.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			Overlay.addChild(CurrentSpeedText);
			
			this.addChild(PopupSprite);
			
			popupText.selectable = false;
			popupText.defaultTextFormat = new TextFormat("Verdana", 24, 0xFFFFFF);
			popupText.wordWrap = true;
			
			//Good text field max size
			popupText.x = PopupSprite.x + 115;
			popupText.y = PopupSprite.y + 400;
			popupText.width = 411;
			popupText.height = 191;
			
			if(Global.HIGH_QUALITY) popupText.filters = new Array(new GlowFilter(0x337C8C, 1, 7, 7, 3));
			PopupSprite.addChild(popupText);
			PopupSprite.addChild(popupCloseMessage);
			
			popupCloseMessage.selectable = false;
			popupCloseMessage.defaultTextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
			popupCloseMessage.autoSize = TextFieldAutoSize.LEFT;
			popupCloseMessage.text = "Press Enter, Space or Left Click to continue.";
			if(Global.HIGH_QUALITY) popupCloseMessage.filters = new Array(new GlowFilter(0x337C8C, 1, 7, 7, 3));
			popupCloseMessage.alpha = 0;
			
			UpdateCache();
			
			this.Pause = pauseLoopback;
			this.MockUpdateWorld = mockupdate;
			
			store = new StoreOverlay();
			map = new MapOverlay();
			
			this.addChild(MuteButton);
			MuteButton.addEventListener(MouseEvent.CLICK, MuteClicked, false, 0, true);
			MuteButton.alpha = 0;
		}
		
		public function Update() : void {
			if (stage == null) return;
			
			MinimapSprite.graphics.clear();
			CurrentSpeedText.text = Math.round(player.body.GetLinearVelocity().Length() * 3.6) + "km/h";
			
			if (MissionManager.CurrentDestination() != null) {
				GPSArrow.x = stage.stageWidth/2;
				GPSArrow.y = stage.stageHeight / 2;
				
				var t_angle:Number = Math.atan2(MissionManager.CurrentDestination().y - player.y, MissionManager.CurrentDestination().x - player.x);
				
				GPSArrow.visible = true;
				GPSArrow.rotation = t_angle / Math.PI * 180;
				GPSDistance.text = Math.floor(Math.sqrt(MathHelper.DistanceSquared(MissionManager.CurrentDestination(), new Point(player.x, player.y))) / Global.PHYSICS_SCALE) + "m";
				
				GPSDistance.x = Math.round(Math.cos(t_angle) * 77 + GPSArrow.x - GPSDistance.width/2);
				GPSDistance.y = Math.round(Math.sin(t_angle) * 77 + GPSArrow.y + 12);
			} else {
				GPSArrow.visible = false;
				GPSDistance.text = "";
			}
			
			////////////////////////////////////////// MINIMAP UPDATES
			var mapScale:Number = (ThemeManager.Get("GUI/Minimap.png") as BitmapData).width / 18688;
				
			MinimapSprite.x = stage.stageWidth - MINIMAP_SIZE_R;
			MinimapSprite.y = stage.stageHeight - MINIMAP_SIZE_R;
			
			var mapOffsetX:int = -player.x * mapScale;
			var mapOffsetY:int = -player.y * mapScale;
			
			var mapMAT:Matrix = new Matrix(1, 0, 0, 1, mapOffsetX, mapOffsetY);
			
			MinimapSprite.graphics.lineStyle(1, 0x0);
			MinimapSprite.graphics.beginFill(0x0080C0);
			MinimapSprite.graphics.drawCircle(0, 0, MINIMAP_SIZE_R);
			MinimapSprite.graphics.endFill();
			
			MinimapSprite.graphics.lineStyle();
			MinimapSprite.graphics.beginBitmapFill(ThemeManager.Get("GUI/Minimap.png"), mapMAT, false, false);
			MinimapSprite.graphics.drawCircle(0, 0, MINIMAP_SIZE_R);
			MinimapSprite.graphics.endFill();
			
			MinimapSprite.graphics.beginFill(0xFFFF00);
			MinimapSprite.graphics.drawCircle(0, 0, 3);
			MinimapSprite.graphics.endFill();
			
			if (MissionManager.CurrentDestination() != null) {
				var mapOffsetX2:int;
				var mapOffsetY2:int;
				
				if (MathHelper.Distance(MissionManager.CurrentDestination(), new Point(player.x, player.y)) < MINIMAP_SIZE_R/mapScale) {
					mapOffsetX2 = mapOffsetX + (MissionManager.CurrentDestination().x * mapScale);
					mapOffsetY2 = mapOffsetY + (MissionManager.CurrentDestination().y * mapScale);
				} else {
					var minimap_angle:Number = MathHelper.GetAngleBetween(MissionManager.CurrentDestination(), new Point(player.x, player.y));
					
					mapOffsetX2 = Math.cos(minimap_angle) * MINIMAP_SIZE_R;
					mapOffsetY2 = Math.sin(minimap_angle) * MINIMAP_SIZE_R;
				}
				
				MinimapSprite.graphics.beginFill(0xFF0000);
				MinimapSprite.graphics.drawCircle(mapOffsetX2, mapOffsetY2, 3);
				MinimapSprite.graphics.endFill();
			}
			
			MinimapOverlay.x = stage.stageWidth - MinimapOverlay.width - Overlay.x;
			MinimapOverlay.y = stage.stageHeight - MinimapOverlay.height - Overlay.y;
			
			MinimapOverlaySoundOn.x = stage.stageWidth - MinimapOverlaySoundOn.width - Overlay.x;
			MinimapOverlaySoundOn.y = stage.stageHeight - MinimapOverlaySoundOn.height - Overlay.y;
			
			MuteButton.x = MinimapOverlaySoundOn.x;
			MuteButton.y = MinimapOverlaySoundOn.y;
			
			if (!AudioController.GetMuted()) {
				MinimapOverlaySoundOn.visible = true;
			} else {
				MinimapOverlaySoundOn.visible = false;
			}
			
			///////////////////////////////////////////////// END MINIMAP UPDATES
			
			if (popupAlpha > 0) {
				if (popupFadeOut) {
					popupAlpha -= 0.08;
					if (popupAlpha <= 0) {
						popupText.alpha = 0;
						popupText.text = "";
						
						popupCloseMessage.alpha = 0;
						
						popupMessages.splice(0, 1);
						ShowNextPopup();
					}
				} else {
					if (popupFadeIn) {
						popupAlpha += 0.08;
						if (popupAlpha >= 1) {
							popupText.alpha = 1;
							popupCloseMessage.alpha = 1;
							
							popupFadeIn = false;
							
							//Need 1 frame of update if the popup is a blackout to allow respawn to work
							if(popupMessages[0].blackOut) MockUpdateWorld.call();
						}
					}
					
					if(!popupFadeIn && !popupFadeOut && (Keys.isKeyDown(Keyboard.ENTER) || Mousey.IsClicking() || Keys.isKeyDown(Keyboard.SPACE))) {
						popupFadeOut = true;
					}
				}
				
				popupText.alpha = popupAlpha;
				popupCloseMessage.alpha = popupAlpha;
				
				if (popupMessages.length > 0) {
					PopupSprite.graphics.clear();
					
					var m:Matrix = new Matrix();
					m.createBox(1, 1, 0, (stage.stageWidth - 665) / 2, stage.stageHeight - 240);
					
					if (popupMessages[0].blackOut) {
						PopupSprite.graphics.beginFill(0x0);
						PopupSprite.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
						PopupSprite.graphics.endFill();
					}
					
					PopupSprite.graphics.beginBitmapFill(ThemeManager.Get("GUI/Message board.png"), m, false);
					PopupSprite.graphics.drawRect((stage.stageWidth - 665) / 2, stage.stageHeight - 240, 665, 240);
					PopupSprite.graphics.endFill();
					
					popupText.x = stage.stageWidth / 2 - 285; // PopupSprite.x + 115;
					popupText.y = stage.stageHeight - 200;// PopupSprite.y + 400;
					
					popupCloseMessage.x = stage.stageWidth / 2 - 300;
					popupCloseMessage.y = stage.stageHeight - 30;
					
					if (popupMessages[0].npcNumber != -1) {
						m.createBox(1, 1, 0, stage.stageWidth/2 + 100, stage.stageHeight - 354);
						PopupSprite.graphics.beginBitmapFill(ThemeManager.Get("People/"+popupMessages[0].npcNumber+"_"+popupMessages[0].npcImgIndex+".png"), m, false);
						PopupSprite.graphics.drawRect(stage.stageWidth/2 + 100, stage.stageHeight - 354, 315, 354);
						PopupSprite.graphics.endFill();
					}
				}
				
				PopupSprite.alpha = popupAlpha;
			}
			
			for (var i:int = currentFrameTooltipIndex; i < tooltips.length; i++) {
				tooltips[i].visible = false;
			}
			
			currentFrameTooltipIndex = 0;
			
			if (hasOverlay) {
				this.graphics.clear();
				
				this.graphics.beginFill(0x0);
				this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				this.graphics.endFill();
				
				map.x = (stage.stageWidth - map.width) / 2;
				map.y = (stage.stageHeight - map.height) / 2;
				
				store.x = (stage.stageWidth - store.width) / 2;
				store.y = (stage.stageHeight - store.height) / 2;
				
				map.Update();
			}
		}
		
		private function ShowNextPopup():void {
			if (popupMessages.length > 0) {
				popupText.text = popupMessages[0].message;
				
				popupAlpha = 0.1;
				popupFadeIn = true;
				popupFadeOut = false;
			} else {
				Pause.call();
			}
		}
		
		public function Popup(msg:String, npc:int = 0, npcImageIndex:int = 0, blackout:Boolean = false) :void {
			
			//Message needs to be split up, but this will do for now
			var messages:Array = msg.split("@NB:");
			
			for (var i:int = 0; i < messages.length; i++) {
				var message:String = messages[i];
				var t_blackout:Boolean = blackout;
				
				if (message.length < 3) continue;
				
				var popupData:PopupInfo = new PopupInfo();
				
				var npcID:int = npc;
				var npcII:int = npcImageIndex;
				
				var sI:int = message.indexOf("_");
				
				if (sI < 3 && sI > -1) {
					npcID = parseInt(message.substr(0, sI));
					npcII = parseInt(message.substr(sI + 1, message.indexOf(" ") - sI));
					message = message.substr(message.indexOf(" ") + 1);
				}
				
				if (message.indexOf("@BLACK") > -1) {
					message = message.split("@BLACK").join("");
					t_blackout = true;
				}
				
				popupData.message = message;
				popupData.npcImgIndex = npcII;
				popupData.npcNumber = npcID;
				popupData.blackOut = t_blackout;
				
				popupMessages.push(popupData);
				
				if (popupMessages.length == 1) {
					ShowNextPopup();
					Pause.call();
				}
			}
		}
		
		public function ShowTooltipAt(worldX:int, worldY:int, message:String):void {
			if (tooltips.length == currentFrameTooltipIndex) {
				tooltips.push(new Tooltip("", Tooltip.UP, 25, 200, 0.85));
				Overlay.addChild(tooltips[currentFrameTooltipIndex]);
			}
			
			tooltips[currentFrameTooltipIndex].visible = true;
			tooltips[currentFrameTooltipIndex].SetText(message);
			tooltips[currentFrameTooltipIndex].x = worldX - player.x + stage.stageWidth / 2;
			tooltips[currentFrameTooltipIndex].y = worldY - player.y + stage.stageHeight / 2;
			
			currentFrameTooltipIndex++;
		}
		
		public function UpdateCache() : void {
			CurrentLevelText.text = ReputationHelper.GetCurrentLevel().toString();
			CurrentMoneyText.text = "$" + MoneyHelper.GetBalance();
			
			Overlay.graphics.clear();
			Overlay.graphics.beginFill(0x0000FF);
			Overlay.graphics.drawRect(88, 14, 88 * ReputationHelper.GetPercentageToNextLevel(), 4);
			Overlay.graphics.endFill();
			
			Overlay.graphics.beginFill(0x585858);
			Overlay.graphics.drawRect(80, 26, 94, 18);
			Overlay.graphics.endFill();
			
			Overlay.graphics.beginFill(0xFF0000);
			Overlay.graphics.drawRect(80, 26, 94 * player.HealthPercent, 18);
			Overlay.graphics.endFill();
			
			Overlay.graphics.lineStyle(1);
			
			for (var i:int = 0; i < player.HealthMax; i+=100) {
				Overlay.graphics.moveTo(80 + (i / player.HealthMax) * 94, 26);
				Overlay.graphics.lineTo(80 + (i / player.HealthMax) * 94, 44);
			}
		}
		
		public function ActivateStore():void {
			this.addChild(store);
			hasOverlay = true;
			Overlay.visible = false;
			
			AudioController.PlaySound(AudioStore.MenuPopup);
			store.Redraw();
			
			Pause.call();
		}
		
		public function DeactivateStore():void {
			AudioController.PlaySound(AudioStore.MenuClick);
			
			this.removeChild(store);
			hasOverlay = false;
			Overlay.visible = true;
			
			Pause.call();
			
			player.FixUpgradeValues();
			player.Respawn();
			
			this.graphics.clear();
		}
		
		public function ActivateMap():void {
			if (map.openTime + 250 > getTimer()) {
				return;
			}
			
			AudioController.PlaySound(AudioStore.MenuPopup);
			
			this.addChild(map);
			map.Redraw();
			hasOverlay = true;
			Overlay.visible = false;
			
			Pause.call();
		}
		
		public function DeactivateMap():void {
			AudioController.PlaySound(AudioStore.MenuClick);
			
			this.removeChild(map);
			hasOverlay = false;
			Overlay.visible = true;
			
			Pause.call();
			
			this.graphics.clear();
		}
		
		private function MuteClicked(me:MouseEvent):void {
			AudioController.SetMuted(!AudioController.GetMuted());
		}
		
	}

}