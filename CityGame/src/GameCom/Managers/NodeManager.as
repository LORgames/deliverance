package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.utils.ByteArray;
	import GameCom.GameComponents.Node;
	/**
	 * ...
	 * @author Miles
	 */
	public class NodeManager {
		private var nodeArray:Vector.<Node>;
		
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
				children = new Array();
				for (var j:int = 0; j < nodefile.readByte(); j++) {
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
			/*if (Math.sqrt((carX-(nodeArray[node] as Node).x)*(carX-(nodeArray[node] as Node).x) - (carY-(nodeArray[node] as Node).y)*(carY-(nodeArray[node] as Node).y)) < 20.0) {
				return true;
			} else {
				return false;
			}*/
			
			return false;
		}
		
		public function GetNode(node:int):Node {
			return nodeArray[node];
		}
	}
}