package {
	import GameCom.SystemMain;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import GameCom.SystemMain;
	import LORgames.Engine.Keys;

	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite {
		
		private static var mStage:Stage = null;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			mStage = this.stage;
			Keys.Initialize(this.stage);
			
			this.addChild(new SystemMain());
		}
		
		public static function GetStage():Stage {
			return mStage;
		}

	}

}