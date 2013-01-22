package GameCom.SystemComponents 
{
	/**
	 * ...
	 * @author P. Fox
	 */
	public class ReputationLevel {
		
		public var Name:String;
		public var ReputationRequired:int;
		
		public function ReputationLevel(name:String, repVal:int) {
			this.Name = name;
			this.ReputationRequired = repVal;
		}
		
	}

}