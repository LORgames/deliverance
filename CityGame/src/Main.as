package {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
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
			this.graphics.beginFill(0xFFFFFF)
			this.graphics.drawRect(0, 0, 10000, 10000);
			this.graphics.endFill();
			this.addChild(new TextField());
			(this.getChildAt(0) as TextField).selectable = false;
			(this.getChildAt(0) as TextField).defaultTextFormat = new TextFormat("Verdana", 10, 0x000000);
			(this.getChildAt(0) as TextField).autoSize = TextFieldAutoSize.LEFT;
			(this.getChildAt(0) as TextField).x = 5;
			(this.getChildAt(0) as TextField).y = 5;
			(this.getChildAt(0) as TextField).text = "Preparing and Caching for awesome non-laggy gameplay! (and no loading screens!)\n(Usually takes about 15-20 seconds)";
			
			ThemeManager.Initialize(init);
		}

		protected function init(e:Event = null):void {
			this.graphics.clear();
			this.removeChildAt(0);
			
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