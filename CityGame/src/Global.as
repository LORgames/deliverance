package  {
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class Global {
		//The name of the game
		public static const GAME_NAME:String = "Deliverance";
		
		// Pixels per Meter
		public static const PHYSICS_SCALE:Number = 10.0;
		
		//Seconds between steps
		public static const TIME_STEP:Number = 1.0 / 30.0;
		public static const INV_TIME_STEP:Number = 1 / TIME_STEP;
		
		//Number of iterations for things
		public static const VELOCITY_ITERATIONS:int = 3;
		public static const POSITION_ITERATIONS:int = 7;
		
		//Mochi authentication
		private var _mochiads_game_id:String = "c3ebe5c39a9741ba";
		
		//Storage things
		public static const StorageRevision:int = 1;
		public static const WipeStorageBelowRevision:int = 0;
		
		//Driving direction
		public static var DriveOnLeft:Boolean = false;
	}

}