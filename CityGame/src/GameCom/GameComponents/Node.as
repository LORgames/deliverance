package GameCom.GameComponents 
{
	/**
	 * ...
	 * @author Miles
	 */
	public class Node {
		public var x:Number;
		public var y:Number;
		private var children:Array;
		
		public function Node(x:Number, y:Number, children:Array) {
			this.x = x;
			this.y = y;
			children = children;
		}
		
		public function NextChild():int {
			if (children.length > 1) {
				return children[Math.round(Math.random() * children.length)];
			} else if (children.length == 1) {
				return children[0];
			} else {
				return -1;
			}
		}
	}
}