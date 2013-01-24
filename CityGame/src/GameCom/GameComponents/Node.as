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
			this.children = children.slice();
		}
		
		public function NextChild():int {
			if(children) {
				return children[Math.floor(Math.random() * children.length)];
			}
			
			return -1;
		}
	}
}