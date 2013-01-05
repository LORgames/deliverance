package LORgames.Engine {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	
	public class Keys {
		
		private static var downKeys:Array = new Array();
		
		public static function Initialize(stage:Stage):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyUp, false, 0, true);
			stage.addEventListener(Event.DEACTIVATE, WipeKeys, false, 0, true);
		}
		
		private static function KeyDown(ke:KeyboardEvent):void {
			downKeys[ke.keyCode] = true;
		}
		
		private static function KeyUp(ke:KeyboardEvent):void {
			downKeys[ke.keyCode] = false;
		}
		
		private static function WipeKeys(e:Event):void {
			for (var key:String in downKeys) {
				downKeys[key] = false;
			}
		}
		
		public static function isKeyDown(key:uint):Boolean {
			if (downKeys[key]) {
				return downKeys[key];
			}
			
			return false;
		}
		
	}

}