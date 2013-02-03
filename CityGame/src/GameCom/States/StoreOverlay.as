package GameCom.States {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
	public class StoreOverlay extends Sprite {
		
		private var StoreBackground:Sprite = new Sprite();
		
		private var CloseButton:Button = new Button("Close");
		
		private var SpeedButton:Button = new Button("Speed", 30, 30);
		private var AccelerationButton:Button = new Button("Acceleration", 30, 30);
		private var HealthButton:Button = new Button("Health", 30, 30);
		private var ArmourButton:Button = new Button("Armour", 30, 30);
		private var NOSButton:Button = new Button("NOS", 30, 30);
		
		private var tooltip:Tooltip = new Tooltip("", Tooltip.RIGHT);
		
		public function StoreOverlay() {
			this.addChild(StoreBackground);
			StoreBackground.graphics.beginBitmapFill(ThemeManager.Get("GUI/Shop.png"));
			StoreBackground.graphics.drawRect(0, 0, 800, 600);
			StoreBackground.graphics.endFill();
			
			CloseButton.x = 666; CloseButton.y = 15;
			this.addChild(CloseButton);
			
			SpeedButton.x = 199; SpeedButton.y = 202; SpeedButton.alpha = 0;
			this.addChild(SpeedButton);
			
			AccelerationButton.x = 199; AccelerationButton.y = 278; AccelerationButton.alpha = 0;
			this.addChild(AccelerationButton);
			
			HealthButton.x = 199; HealthButton.y = 355; HealthButton.alpha = 0;
			this.addChild(HealthButton);
			
			ArmourButton.x = 199; ArmourButton.y = 434; ArmourButton.alpha = 0;
			this.addChild(ArmourButton);
			
			NOSButton.x = 199; NOSButton.y = 517; NOSButton.alpha = 0;
			this.addChild(NOSButton);
			
			this.addChild(tooltip);
			
			SpeedButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			AccelerationButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			HealthButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			ArmourButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			NOSButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased);
			
			SpeedButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight);
			AccelerationButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight);
			HealthButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight);
			ArmourButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight);
			NOSButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight);
			
			SpeedButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave);
			AccelerationButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave);
			HealthButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave);
			ArmourButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave);
			NOSButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave);
			
			CloseButton.addEventListener(MouseEvent.CLICK, OnCloseClicked);
			
			RedrawStats();
		}
		
		public function Redraw():void {
			if (!stage) return;
		}
		
		private function OnCloseClicked(me:MouseEvent):void {
			GUIManager.I.DeactivateStore();
		}
		
		private function OnUpgradePurchased(me:MouseEvent):void {
			var stat:String = me.currentTarget.getLabel();
			var statVal:int = Storage.GetAsInt(stat + "Upgrade");
			
			if (statVal < 10) {
				if (MoneyHelper.CanDebit(UpgradeHelper.GetCost(stat, statVal+1))) {
					MoneyHelper.Debit(UpgradeHelper.GetCost(stat, statVal+1));
					Storage.Set(stat + "Upgrade", statVal + 1);
				}
			}
			
			OnUpgradeHighlight(me);
			
			RedrawStats();
		}
		
		private function OnUpgradeHighlight(me:MouseEvent):void {
			var statVal:int;
			
			var stat:String = me.currentTarget.getLabel();
			
			statVal = Storage.GetAsInt((me.currentTarget as Button).getLabel() + "Upgrade");
			
			tooltip.x = me.currentTarget.x + me.currentTarget.width;
			tooltip.y = me.currentTarget.y + me.currentTarget.height / 2;
			
			if (statVal == 10) {
				tooltip.SetText("ALREADY MAX");
			} else {
				tooltip.SetText("Level " + (statVal+1) + " " + stat + " costs $" + UpgradeHelper.GetCost(stat, statVal+1) + ".\n\nCurrent Benefit: " + UpgradeHelper.GetBenefit(stat, statVal) + "\nNext Level: " + UpgradeHelper.GetBenefit(me.currentTarget.getLabel(), statVal+1) + "\n\nBalance After Purchase: " + MoneyHelper.GetBalanceAfterPurchase(UpgradeHelper.GetCost(stat, statVal+1)) + "\n\n" + (MoneyHelper.CanDebit(UpgradeHelper.GetCost(stat, statVal+1))?"Click To Purcahse":"You cannot purchase at this time"));
			}
			
			tooltip.visible = true;
		}
		
		private function OnUpgradeLeave(me:MouseEvent):void {
			tooltip.visible = false;
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