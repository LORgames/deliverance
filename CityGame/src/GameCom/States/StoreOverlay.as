package GameCom.States {
	import Box2D.Common.b2Color;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.UpgradeHelper;
	import GameCom.Managers.GUIManager;
	import LORgames.Components.Button;
	import LORgames.Components.TextBox;
	import LORgames.Components.Tooltip;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author ...
	 */
	public class StoreOverlay extends Sprite {
		
		private var StoreBackground:Sprite = new Sprite();
		
		private var CloseButton:Button = new Button("Close", 100, 30, 36, [new GlowFilter(0x337C8C)], true);
		
		private var SpeedButton:Button = new Button("Speed", 30, 30);
		private var AccelerationButton:Button = new Button("Acceleration", 30, 30);
		private var HealthButton:Button = new Button("Health", 30, 30);
		private var ArmourButton:Button = new Button("Armour", 30, 30);
		private var NOSButton:Button = new Button("Damage", 30, 30);
		
		private var MachineGun:Button = new Button("Machine Gun", 241, 84);
		private var Laser:Button = new Button("Laser", 241, 84);
		
		private var CabColourButtons:Vector.<Button> = new Vector.<Button>();
		private var TrailerColourButtons:Vector.<Button> = new Vector.<Button>();
		
		private var CurrencyTB:TextField = new TextField();
		
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
			MachineGun.addEventListener(MouseEvent.MOUSE_OVER, OnWeaponHighlight, false, 0, true);
			MachineGun.addEventListener(MouseEvent.MOUSE_OUT, OnWeaponLeave, false, 0, true);
			
			Laser.x = 295; Laser.y = 292; Laser.alpha = 0;
			this.addChild(Laser);
			Laser.addEventListener(MouseEvent.CLICK, ChangeWeapon, false, 0, true);
			Laser.addEventListener(MouseEvent.MOUSE_OVER, OnWeaponHighlight, false, 0, true);
			Laser.addEventListener(MouseEvent.MOUSE_OUT, OnWeaponLeave, false, 0, true);
			
			CabColourButtons.push(	new Button("C0", 18, 18),
									new Button("C1", 18, 18),
									new Button("C2", 18, 18),
									new Button("C3", 18, 18),
									new Button("C4", 18, 18),
									new Button("C5", 18, 18),
									new Button("C6", 18, 18),
									new Button("C7", 18, 18),
									new Button("C8", 18, 18),
									new Button("C9", 18, 18));
			
			TrailerColourButtons.push(	new Button("T0", 18, 18),
										new Button("T1", 18, 18),
										new Button("T2", 18, 18),
										new Button("T3", 18, 18),
										new Button("T4", 18, 18),
										new Button("T5", 18, 18),
										new Button("T6", 18, 18),
										new Button("T7", 18, 18),
										new Button("T8", 18, 18),
										new Button("T9", 18, 18));
			
			for (var i:int = 0; i < 10; i++) {
				CabColourButtons[i].x = 293 + (i%5 * 26); CabColourButtons[i].y = i<5?496:523; CabColourButtons[i].alpha = 0;
				this.addChild(CabColourButtons[i]);
				CabColourButtons[i].addEventListener(MouseEvent.CLICK, ChangeColour, false, 0, true);
				CabColourButtons[i].addEventListener(MouseEvent.MOUSE_OVER, OnColourHighlight, false, 0, true);
				CabColourButtons[i].addEventListener(MouseEvent.MOUSE_OUT, OnColourLeave, false, 0, true);
			}
			
			for (var j:int = 0; j < 10; j++) {
				TrailerColourButtons[j].x = 453 + (j%5 * 26); TrailerColourButtons[j].y = j<5?496:523; TrailerColourButtons[j].alpha = 0;
				this.addChild(TrailerColourButtons[j]);
				TrailerColourButtons[j].addEventListener(MouseEvent.CLICK, ChangeColour, false, 0, true);
				TrailerColourButtons[j].addEventListener(MouseEvent.MOUSE_OVER, OnColourHighlight, false, 0, true);
				TrailerColourButtons[j].addEventListener(MouseEvent.MOUSE_OUT, OnColourLeave, false, 0, true);
			}
			
			CloseButton.addEventListener(MouseEvent.CLICK, OnCloseClicked);
			
			CurrencyTB.selectable = false;
			CurrencyTB.defaultTextFormat = new TextFormat("Verdana", 20, 0xFFFF70);
			CurrencyTB.x = 128;
			CurrencyTB.y = 10;
			CurrencyTB.autoSize = TextFieldAutoSize.LEFT;
			CurrencyTB.filters = new Array(new GlowFilter(0, 1, 2, 2, 5));
			this.addChild(CurrencyTB);
			
			CurrencyTB.text = "$" + MoneyHelper.GetBalance();
			
			tooltip.visible = false;
			
			RedrawStats();
		}
		
		public function Redraw():void {
			if (!stage) return;
		}
		
		private function OnCloseClicked(me:MouseEvent):void {
			GUIManager.I.DeactivateStore();
		}
		
		private function OnUpgradePurchased(me:MouseEvent):void {
			AudioController.PlaySound(AudioStore.MenuClick);
			
			var stat:String = me.currentTarget.getLabel();
			var statVal:int = Storage.GetAsInt(stat + "Upgrade");
			
			if (statVal < 10) {
				if (MoneyHelper.CanDebit(UpgradeHelper.GetCost(stat, statVal+1))) {
					MoneyHelper.Debit(UpgradeHelper.GetCost(stat, statVal+1));
					Storage.Set(stat + "Upgrade", statVal + 1);
				}
			}
			
			CurrencyTB.text = "$" + MoneyHelper.GetBalance();
			
			OnUpgradeHighlight(me);
			
			RedrawStats();
		}
		
		private function OnUpgradeHighlight(me:MouseEvent):void {
			var statVal:int;
			
			var stat:String = me.currentTarget.getLabel();
			
			statVal = Storage.GetAsInt((me.currentTarget as Button).getLabel() + "Upgrade");
			
			tooltip.x = me.currentTarget.x + 20;
			tooltip.y = me.currentTarget.y + me.currentTarget.height / 2;
			
			if (statVal == 10) {
				tooltip.SetText("ALREADY MAX");
			} else {
				tooltip.SetText("Level " + (statVal+1) + " " + stat + " costs $" + UpgradeHelper.GetCost(stat, statVal+1) + ".\n\nCurrent Benefit: " + UpgradeHelper.GetBenefit(stat, statVal) + "\nNext Level: " + UpgradeHelper.GetBenefit(me.currentTarget.getLabel(), statVal+1) + "\n\nBalance After Purchase: " + MoneyHelper.GetBalanceAfterPurchase(UpgradeHelper.GetCost(stat, statVal+1)) + "\n\n" + (MoneyHelper.CanDebit(UpgradeHelper.GetCost(stat, statVal+1))?"<font color='#00FF00'>Click To Purchase</font>":"<font color='#FF0000'>You cannot purchase at this time</font>"));
			}
			
			tooltip.visible = true;
		}
		
		private function OnUpgradeLeave(me:MouseEvent):void {
			tooltip.visible = false;
		}
		
		private function ChangeWeapon(me:MouseEvent):void {
			AudioController.PlaySound(AudioStore.MenuClick);
			
			var weapon:String = me.currentTarget.getLabel();
			var available:Boolean = false;
			
			if (weapon != GUIManager.I.player.GetWeapon()) {
				switch(weapon) {
					case "Machine Gun":
						available = ReputationHelper.GetCurrentLevel() >= 5;
						break;
					case "Laser":
						available = Storage.GetAsInt("TotalCollectablesFound") >= 50;
						break;
					default:
						break;
				}
			}
			
			if (available) {
				GUIManager.I.player.EquipWeapon(weapon);
				tooltip.visible = false;
			}
		}
		
		private function OnWeaponHighlight(me:MouseEvent):void {
			var weapon:String = me.currentTarget.getLabel();
			var available:Boolean = false;
			
			tooltip.x = me.currentTarget.x + 231;
			tooltip.y = me.currentTarget.y + me.currentTarget.height / 2;
			
			if (weapon == GUIManager.I.player.GetWeapon()) {
				tooltip.SetText(weapon + "\n\n<font color='#FF0000'>Already equipped!</font>");
			} else {
				switch(weapon) {
					case "Machine Gun":
						available = ReputationHelper.GetCurrentLevel() >= 5;
						tooltip.SetText(weapon + "\n\n" + (available?"<font color='#00FF00'>Click to equip!</font>":"<font color='#FF0000'>Gain more reputation to unlock this weapon!</font>"));
						break;
					case "Laser":
						available = Storage.GetAsInt("TotalCollectablesFound") >= 50;
						tooltip.SetText(weapon + "\n\n" + (available?"<font color='#00FF00'>Click to equip!</font>":"<font color='#FF0000'>Find more collectibles to unlock this weapon!</font>"));
						break;
					default:
						break;
				}
			}
			tooltip.visible = true;
		}
		
		private function OnWeaponLeave(me:MouseEvent):void {
			tooltip.visible = false;
		}
		
		private function ChangeColour(me:MouseEvent):void {
			var part:String = me.currentTarget.getLabel().charAt(0);
			var col:int = parseInt(me.currentTarget.getLabel().charAt(1));
			switch(part) {
				case "C":
					if (MoneyHelper.CanDebit(100)) {
						MoneyHelper.Debit(100);
						GUIManager.I.player.getChildAt(2).transform.colorTransform = GUIManager.I.player.Colours[col];
						Storage.Set(part+"Colour", col);
					}
					break;
				case "T":
					if (MoneyHelper.CanDebit(100)) {
						MoneyHelper.Debit(100);
						GUIManager.I.player.getChildAt(3).transform.colorTransform = GUIManager.I.player.Colours[col];
						Storage.Set(part+"Colour", col);
					}
					break;
				default:
					break;
			}
		}
		
		private function OnColourHighlight(me:MouseEvent):void {
			tooltip.x = me.currentTarget.x + 18;
			tooltip.y = me.currentTarget.y + me.currentTarget.height / 2;
			
			tooltip.SetText("Paint job costs $100\n\nBalance After Purchase: " + MoneyHelper.GetBalanceAfterPurchase(100) + "\n\n" + (MoneyHelper.CanDebit(100)?"<font color='#00FF00'>Click To Purchase</font>":"<font color='#FF0000'>You cannot purchase at this time</font>"));
			
			tooltip.visible = true;
		}
		
		private function OnColourLeave(me:MouseEvent):void {
			tooltip.visible = false;
		}
		
		private function RedrawStats():void {
			var s0:int = Storage.GetAsInt("SpeedUpgrade");
			var s1:int = Storage.GetAsInt("AccelerationUpgrade");
			var s2:int = Storage.GetAsInt("HealthUpgrade");
			var s3:int = Storage.GetAsInt("ArmourUpgrade");
			var s4:int = Storage.GetAsInt("DamageUpgrade");
			
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