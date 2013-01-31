package GameCom.States {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import GameCom.Managers.GUIManager;
	import LORgames.Components.Button;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author ...
	 */
	public class StoreOverlay extends Sprite {
		
		private var StoreBackground:Sprite = new Sprite();
		
		private var CloseButton:Button = new Button("Close");
		
		private var SpeedButton:Button = new Button("$", 30, 30);
		private var AccelerationButton:Button = new Button("$", 30, 30);
		private var HealthButton:Button = new Button("$", 30, 30);
		private var ArmourButton:Button = new Button("$", 30, 30);
		private var NOSButton:Button = new Button("$", 30, 30);
		
		public function StoreOverlay() {
			this.addChild(StoreBackground);
			StoreBackground.graphics.beginBitmapFill(ThemeManager.Get("GUI/Shop.png"));
			StoreBackground.graphics.drawRect(0, 0, 800, 600);
			StoreBackground.graphics.endFill();
			
			CloseButton.x = 666; CloseButton.y = 15;
			this.addChild(CloseButton);
			
			SpeedButton.x = 199; SpeedButton.y = 202;
			this.addChild(SpeedButton);
			
			AccelerationButton.x = 199; AccelerationButton.y = 278;
			this.addChild(AccelerationButton);
			
			HealthButton.x = 199; HealthButton.y = 355;
			this.addChild(HealthButton);
			
			ArmourButton.x = 199; ArmourButton.y = 434;
			this.addChild(ArmourButton);
			
			NOSButton.x = 199; NOSButton.y = 517;
			this.addChild(NOSButton);
			
			SpeedButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			AccelerationButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			HealthButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			ArmourButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			NOSButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			
			CloseButton.addEventListener(MouseEvent.CLICK, OnCloseClicked);
		}
		
		public function Redraw():void {
			if (!stage) return;
		}
		
		private function OnCloseClicked(me:MouseEvent):void {
			GUIManager.I.DeactivateStore();
		}
		
		private function OnUpgradePurchased(me:MouseEvent):void {
			var stat:int;
			
			if (me.currentTarget == SpeedButton) {
				stat = Storage.GetAsInt("SpeedUpgrade");
				if(stat < 10) Storage.Set("SpeedUpgrade", stat + 1);
			} else if (me.currentTarget == AccelerationButton) {
				stat = Storage.GetAsInt("AccelerationUpgrade");
				if(stat < 10) Storage.Set("AccelerationUpgrade", stat + 1);
			} else if (me.currentTarget == HealthButton) {
				stat = Storage.GetAsInt("HealthUpgrade");
				if(stat < 10) Storage.Set("HealthUpgrade", stat + 1);
			} else if (me.currentTarget == ArmourButton) {
				stat = Storage.GetAsInt("ArmourUpgrade");
				if(stat < 10) Storage.Set("ArmourUpgrade", stat + 1);
			} else if (me.currentTarget == NOSButton) {
				stat = Storage.GetAsInt("NOSUpgrade");
				if(stat < 10) Storage.Set("NOSUpgrade", stat + 1);
			}
			
			RedrawStats();
		}
		
		private function RedrawStats():void {
			var s0:int = Storage.GetAsInt("SpeedUpgrade");
			var s1:int = Storage.GetAsInt("AccelerationUpgrade");
			var s2:int = Storage.GetAsInt("HealthUpgrade");
			var s3:int = Storage.GetAsInt("ArmourUpgrade");
			var s4:int = Storage.GetAsInt("NOSUpgrade");
			
			this.graphics.clear();
			
			this.graphics.beginFill(0x191B27, 1);
			this.graphics.drawRect(75, 201, 125, 350);
			this.graphics.endFill();
			
			this.graphics.beginFill(0xFF0000, 1);
			
			this.graphics.drawRect(75, 201, 11 * s0, 36);
			this.graphics.drawRect(75, 277, 11 * s1, 36);
			this.graphics.drawRect(75, 353, 11 * s2, 36);
			this.graphics.drawRect(75, 434, 11 * s3, 36);
			this.graphics.drawRect(75, 515, 11 * s4, 36);
			
			this.graphics.endFill();
		}
		
	}

}