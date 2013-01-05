package  {
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class Global {
		
		//The name of the game
		public static const GAME_NAME:String = "Ultimate Lorry Attack Extreme";
		
		//The UI scaling factor (pretty damned important now that its needed everywhere... sigh)
		public static var UI_SCALE:Number = 1.0;
		
		// Pixels per Meter
		public static const PHYSICS_SCALE:Number = 20.0;
		
		//Seconds between steps
		public static const TIME_STEP:Number = 1.0 / 30.0;
		public static const INV_TIME_STEP:Number = 1 / TIME_STEP;
		
		//Number of iterations for things
		public static const VELOCITY_ITERATIONS:int = 7;
		public static const POSITION_ITERATIONS:int = 3;
		
		//Server name and directory
		public static const SERVER_ADDR:String = "http://localhost/bridge/";
	}

}