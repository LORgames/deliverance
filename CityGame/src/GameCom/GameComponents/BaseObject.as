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
		
		public function BaseObject() {
			
		}

        //Draw function
        public function Draw(buffer:Graphics):void {
            throw new String("Not implemented!");
        }

        public function CompareTo(other:BaseObject):int {
            if (index < other.index) return 1;
			if (index > other.index) return -1;
			return 0;
        }
		
	}

}