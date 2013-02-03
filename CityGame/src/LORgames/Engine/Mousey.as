package LORgames.Engine 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Paul
	 */
	public class Mousey	{
		
		private static var _Pos:Point = new Point();
		private static var _LClick:Boolean = false;
		
		public static function Initialize(stage:Stage):void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, MouseUp, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, MouseUp_Event, false, 0, true);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseMove, false, 0, true);
		}
		
		public static function GetPosition():Point {
			return _Pos;
		}
		
		public static function IsClicking():Boolean {
			return _LClick;
		}
		
		private static function MouseDown(me:MouseEvent):void {
			_LClick = true;
		}
		
		private static function MouseUp(me:MouseEvent):void {
			_LClick = false;
		}
		
		private static function MouseUp_Event(me:Event):void {
			_LClick = false;
		}
		
		private static function MouseMove(me:MouseEvent):void {
			_Pos.x = me.stageX;
			_Pos.y = me.stageY;
		}
		
	}

}