package GameCom.GameComponents 
{
	import Box2D.Dynamics.b2Body;
	import flash.display.Graphics;
	/**
	 * ...
	 * @author Paul
	 */
	public class BaseObject {
		//Circular references
        public var baseBody:b2Body;
		public var index:int = 0;
		
		private static var CURRENT_INDEX:int = 0;
		
		public function BaseObject() {
			index = CURRENT_INDEX++;
		}
		
		public static function Compare(a:BaseObject, b:BaseObject) : int {
			if (a.index < b.index) {
				return -1;
			} else if (a.index > b.index) {
				return 1;
			} else {
				return 0;
			}
		}

        //Draw function
        public function Draw(buffer:Graphics):void {
            throw new String("Not implemented!");
        }
	}

}