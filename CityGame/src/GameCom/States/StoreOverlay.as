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
		
		private var MachineGun:Button = new Button("MachineGun", 241, 84);
		private var RocketPod:Button = new Button("RocketPod", 241, 84);
		private var Laser:Button = new Button("Laser", 241, 84);
		
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
			
			SpeedButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased, false, 0, true);
			AccelerationButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased, false, 0, true);
			HealthButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased, false, 0, true);
			ArmourButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased, false, 0, true);
			NOSButton.addEventListener(MouseEvent.CLICK, OnUpgradePurchased, false, 0, true);
			
			SpeedButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight, false, 0, true);
			AccelerationButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight, false, 0, true);
			HealthButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight, false, 0, true);
			ArmourButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight, false, 0, true);
			NOSButton.addEventListener(MouseEvent.MOUSE_OVER, OnUpgradeHighlight, false, 0, true);
			
			SpeedButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave, false, 0, true);
			AccelerationButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave, false, 0, true);
			HealthButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave, false, 0, true);
			ArmourButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave, false, 0, true);
			NOSButton.addEventListener(MouseEvent.MOUSE_OUT, OnUpgradeLeave, false, 0, true);
			
			MachineGun.x = 295; MachineGun.y = 201; MachineGun.alpha = 0;
			this.addChild(MachineGun);
			MachineGun.addEventListener(MouseEvent.CLICK, ChangeWeapon, false, 0, true);
			
			RocketPod.x = 295; RocketPod.y = 292; RocketPod.alpha = 0;
			this.addChild(RocketPod);
			RocketPod.addEventListener(MouseEvent.CLICK, ChangeWeapon, false, 0, true);
			
			Laser.x = 295; Laser.y = 383; Laser.alpha = 0;
			this.addChild(Laser);
			Laser.addEventListener(MouseEvent.CLICK, ChangeWeapon, false, 0, true);
			
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
			
			tooltip.x = me.currentTarget.x + 20;
			tooltip.y = me.currentTarget.y + me.currentTarget.height / 2;
			
			trace(me.currentTarget.width);
			
			if (statVal == 10) {
				tooltip.SetText("ALREADY MAX");
			} else {
				tooltip.SetText("Level " + (statVal+1) + " " + stat + " costs $" + UpgradeHelper.GetCost(stat, statVal+1) + ".\n\nCurrent Benefit: " + UpgradeHelper.GetBenefit(stat, statVal) + "\nNext Level: " + UpgradeHelper.GetBenefit(me.currentTarget.getLabel(), statVal+1) + "\n\nBalance After Purchase: " + MoneyHelper.GetBalanceAfterPurchase(UpgradeHelper.GetCost(stat, statVal+1)) + "\n\n" + (MoneyHelper.CanDebit(UpgradeHelper.GetCost(stat, statVal+1))?"<font color='#00FF00'>Click To Purcahse</font>":"<font color='#FF0000'>You cannot purchase at this time</font>"));
			}
			
			tooltip.visible = true;
		}
		
		private function OnUpgradeLeave(me:MouseEvent):void {
			tooltip.visible = false;
		}
		
		private function ChangeWeapon(me:MouseEvent):void {
			var weapon:String = me.currentTarget.getLabel();
			
			if(weapon != "RocketPod") {
				GUIManager.I.player.EquipWeapon(weapon);
				tooltip.visible = false;
			} else {
				tooltip.x = me.stageX;
				tooltip.y = me.stageY;
				tooltip.SetText("<font color='#FF0000'>Unlocks at level 21!</font>");
				tooltip.visible = true;
			}
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