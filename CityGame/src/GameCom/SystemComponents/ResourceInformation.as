package GameCom.SystemComponents {
	/**
	 * ...
	 * @author ...
	 */
	public class ResourceInformation {
		
		public var ID:int;
		public var Name:String;
		public var ValuePerItem:int;
		public var MinimumLoad:int;
		public var MaximumLoad:int;
		public var Message:String;
		public var ReputationForUnlock:int;
		public var ReputationGainPerItem:Number;
		
		public function ResourceInformation(id:int, name:String, value:int, minLoad:int, maxLoad:int, message:String, unlockAt:int, repPerItem:Number) {
			this.ID = id;
			this.Name = name;
			this.ValuePerItem = value;
			this.MinimumLoad = minLoad;
			this.MaximumLoad = maxLoad;
			this.Message = message;
			this.ReputationForUnlock = unlockAt;
			this.ReputationGainPerItem = repPerItem;
		}
		
	}

}