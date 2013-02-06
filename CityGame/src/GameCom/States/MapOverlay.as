package GameCom.States {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.UpgradeHelper;
	import GameCom.Managers.GUIManager;
	import LORgames.Components.Button;
	import LORgames.Components.Tooltip;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author ...
	 */
	public class MapOverlay extends Sprite {
		private var CloseButton:Button = new Button("Close");
		
		private var tooltip:Tooltip = new Tooltip("", Tooltip.RIGHT);
		
		private const MAP_SCALE:Number = 0.042404325241174599809180536414714;
		
		public function MapOverlay() {
			CloseButton.addEventListener(MouseEvent.CLICK, OnCloseClicked);
		}
		
		public function Redraw():void {
			if (!stage) return;
			
			this.graphics.beginBitmapFill(ThemeManager.Get("GUI/Map.png"));
			this.graphics.drawRect(0, 0, 800, 600);
			this.graphics.endFill();
			
			var m:Matrix = new Matrix();
			
			var xP:Number = GUIManager.I.player.x * MAP_SCALE;
			var xY:Number = GUIManager.I.player.y * MAP_SCALE;
			
			var bmpd:BitmapData = ThemeManager.Get("GUI/Truck Marker.png");
			m.createBox(1, 1, 0, xP, xY);
			
			this.graphics.beginBitmapFill(bmpd, m);
			this.graphics.drawRect(xY, xY, bmpd.width, bmpd.height);
			this.graphics.endFill();
			
			//Need to draw many things here?
		}
		
		private function OnCloseClicked(me:MouseEvent):void {
			GUIManager.I.DeactivateMap();
		}
		
	}

}