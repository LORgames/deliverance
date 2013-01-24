package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import GameCom.GameComponents.Node;
	/**
	 * ...
	 * @author Miles
	 */
	public class NodeManager {
		private var nodeArray:Vector.<Node>;
		
		private const TOUCH_SQUARED:Number = 5000;
		
		public function NodeManager() {
			// load in nodes
			var nodefile:ByteArray = ThemeManager.Get("2.map");
			
			var numnodes:int = nodefile.readInt();
			var x:Number;
			var y:Number;
			var children:Array;
			nodeArray = new Vector.<Node>();
			
			for (var i:int = 0; i < numnodes; i++) {
				x = nodefile.readFloat();
				y = nodefile.readFloat();
				
				var totalChildren:int = nodefile.readByte();
				
				children = new Array();
				for (var j:int = 0; j < totalChildren; j++) {
					children.push(nodefile.readInt());
				}
				
				nodeArray.push(new Node(x, y, children));
			}
		}
		
		public function NextNode(node:int):int {
			return nodeArray[node].NextChild();
		}
		
		public function FirstNode(carX:Number, carY:Number):int {
			return 0;
		}
		
		public function TouchNode(node:int, carX:Number, carY:Number):Boolean {
			//TODO: Fix this.
			if (PythagSqr(new Point(nodeArray[node].x, nodeArray[node].y), new Point(carX, carY)) < TOUCH_SQUARED) {
				return true;
			} else {
				return false;
			}
			
			return false;
		}
		
		public function GetNode(node:int):Node {
			if(node >= 0 && node < nodeArray.length) {
				return nodeArray[node];
			}
			
			return null;
		}
		
		public function GetNearestNode(x:Number, y:Number):int {
			var currentNearestIndex:int = 0;
			var currentNearestSqr:Number = Number.MAX_VALUE;
			
			var p:Point = new Point(x, y);
			
			for (var i:int = 0; i < nodeArray.length; i++) {
				var thisDist:Number = PythagSqr(new Point(nodeArray[i].x, nodeArray[i].y), p);
				
				if (thisDist < currentNearestSqr) {
					currentNearestSqr = thisDist;
					currentNearestIndex = i;
				}
			}
			
			return currentNearestIndex;
		}
		
		private function PythagSqr(n:Point, p:Point):Number {
			return (n.x - p.x) * (n.x - p.x) + (n.y - p.y) * (n.y - p.y);
		}
	}
}