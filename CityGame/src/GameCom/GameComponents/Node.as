package GameCom.GameComponents 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Miles
	 */
	public class Node {
		public var p:Point;
		
		public var x:Number;
		public var y:Number;
		
		public var parents:Array = new Array();
		public var children:Array;
		
		public function Node(x:Number, y:Number, children:Array) {
			this.x = x;
			this.y = y;
			
			this.p = new Point(x, y);
			
			this.children = children.slice();
		}
		
		public function NextChild():int {
			if(Global.DriveOnLeft) {
				if(children) {
					return children[Math.floor(Math.random() * children.length)];
				}
			} else {
				if(parents) {
					return parents[Math.floor(Math.random() * parents.length)];
				}
			}
			
			return -1;
		}
	}
}