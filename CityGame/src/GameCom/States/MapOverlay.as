package GameCom.States {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.UpgradeHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.MissionManager;
	import GameCom.Managers.PlacesManager;
	import LORgames.Components.Button;
	import LORgames.Components.Tooltip;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author ...
	 */
	public class MapOverlay extends Sprite {
		private var CloseButton:Button = new Button("Close", 100, 30, 36, [new GlowFilter(0x337C8C)], true);
		
		private var tooltip:Tooltip = new Tooltip("", Tooltip.RIGHT);
		
		private const MAP_SCALE:Number = 1 / 21.3;
		private const MAP_OFFSET_X:Number = -26;
		private const MAP_OFFSET_Y:Number = -300;
		
		public var openTime:int = 0;
		
		public function MapOverlay() {
			this.addEventListener(Event.ADDED_TO_STAGE, Added);
			
			CloseButton.addEventListener(MouseEvent.CLICK, OnCloseClicked);
			this.addChild(CloseButton);
			CloseButton.x = 20;
			CloseButton.y = 20;
		}
		
		public function Redraw():void {
			if (!stage) return;
			
			this.graphics.beginBitmapFill(ThemeManager.Get("GUI/Map.png"));
			this.graphics.drawRect(0, 0, 800, 600);
			this.graphics.endFill();
			
			var m:Matrix = new Matrix();
			
			var bmpd:BitmapData = ThemeManager.Get("GUI/Truck Marker.png");
			var xX:Number = GUIManager.I.player.x * MAP_SCALE + MAP_OFFSET_X - bmpd.width / 2;
			var xY:Number = GUIManager.I.player.y * MAP_SCALE + MAP_OFFSET_Y - (0.7 * bmpd.height);
			
			m.createBox(1, 1, 0, xX, xY);
			
			this.graphics.beginBitmapFill(bmpd, m);
			this.graphics.drawRect(xX, xY, bmpd.width, bmpd.height);
			this.graphics.endFill();
			
			if (MissionManager.IsInMission()) {
				var bmpd2:BitmapData = ThemeManager.Get("GUI/Destination Marker.png");
				
				var yX:Number = MissionManager.CurrentDestination().x * MAP_SCALE + MAP_OFFSET_X - bmpd2.width/2;
				var yY:Number = MissionManager.CurrentDestination().y * MAP_SCALE + MAP_OFFSET_Y - bmpd2.height*0.9;
				
				m.createBox(1, 1, 0, yX, yY);
				
				this.graphics.beginBitmapFill(bmpd2, m);
				this.graphics.drawRect(yX, yY, bmpd2.width, bmpd2.height);
				this.graphics.endFill();
			} else {
				var bmpd3:BitmapData = ThemeManager.Get("GUI/Pickup points.png");
				
				for (var i:int = 0; i < PlacesManager.instance.PickupLocations.length; i++) {
					if (PlacesManager.instance.PickupLocations[i].isActive) {
						var zX:Number = PlacesManager.instance.PickupLocations[i].drawX * MAP_SCALE + MAP_OFFSET_X - bmpd3.width/2;
						var zY:Number = PlacesManager.instance.PickupLocations[i].drawY * MAP_SCALE + MAP_OFFSET_Y - bmpd3.height/2;
						
						m.createBox(1, 1, 0, zX, zY);
						
						this.graphics.beginBitmapFill(bmpd3, m);
						this.graphics.drawRect(zX, zY, bmpd3.width, bmpd3.height);
						this.graphics.endFill();
					}
				}
			}
			
			//Need to draw many things here?
		}
		
		public function Added(e:Event):void {
			openTime = getTimer();
		}
		
		private function OnCloseClicked(me:MouseEvent):void {
			GUIManager.I.DeactivateMap();
			openTime = getTimer();
		}
		
		public function Update():void {
			if (this.parent != null && Keys.isKeyDown(Keyboard.M) && getTimer() > openTime+250) {
				OnCloseClicked(null);
			}
		}
		
	}

}