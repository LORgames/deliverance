package GameCom.Helpers 
{
	import GameCom.SystemComponents.Stat;
	import LORgames.Engine.Stats;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author ...
	 */
	public class MoneyHelper {
		
		private static var currentMoney:int = 0;
		private static const MAX_MONEY:int = 1000000;
		
		public static function Initialize():void {
			currentMoney = Storage.GetAsInt("Money", 20);
		}
		
		public static function Credit(creditAmount:int):void {
			currentMoney += creditAmount;
			
			if (currentMoney > MAX_MONEY)
				currentMoney = MAX_MONEY;
				
			Storage.Set("Money", currentMoney);
			
			Stats.AddValue(Stat.TOTAL_MONEY_GAINED, creditAmount);
			Stats.SetHighestInt(Stat.HIGHEST_MONEY, currentMoney);
			Stats.SetHighestInt(Stat.HIGHEST_MONEY_INCREASE, creditAmount);
		}
		
		public static function Debit(debitAmount:int):void {
			currentMoney -= debitAmount
			
			Storage.Set("Money", currentMoney);
			
			Stats.AddValue(Stat.TOTAL_MONEY_SPENT, debitAmount);
		}
		
		public static function CanCredit(creditAmount:int):Boolean {
			if (currentMoney+creditAmount <= MAX_MONEY) {
				return true;
			}
			
			return false;
		}
		
		public static function CanDebit(debitAmount:int):Boolean {
			if (currentMoney >= debitAmount) {
				return true;
			}
			
			return false;
		}
		
		public static function GetBalance():int {
			return currentMoney;
		}
		
		public static function GetBalanceAfterPurchase(cost:int):String {
			if(currentMoney - cost < 0) {
				return "-$" + Math.abs(currentMoney - cost);
			} else {
				return "$" + (currentMoney - cost);
			}
		}
		
	}

}