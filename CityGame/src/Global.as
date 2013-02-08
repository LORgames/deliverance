package  {
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class Global {
		//The name of the game
		public static const GAME_NAME:String = "Deliverance";
		
		//The UI scaling factor (pretty damned important now that its needed everywhere... sigh)
		public static var UI_SCALE:Number = 1.0;
		
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
		
		//Use local steering?
		public static var UseGlobalSteering:Boolean = false;
	}

}