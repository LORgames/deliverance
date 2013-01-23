package GameCom.Helpers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class MoneyHelper {
		
		private static var currentMoney:int = 0;
		private static const MAX_MONEY:int = 1000000;
		
		public static function Initialize(startingMoney:int):void {
			currentMoney = startingMoney;
		}
		
		public static function Credit(creditAmount:int):void {
			currentMoney += creditAmount;
			
			if (currentMoney > MAX_MONEY)
				currentMoney = MAX_MONEY;
		}
		
		public static function Debit(debitAmount:int):void {
			currentMoney -= debitAmount;
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
		
	}

}