package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import GameCom.GameComponents.Node;
	import GameCom.Helpers.MathHelper;
	/**
	 * ...
	 * @author Miles
	 */
	public class NodeManager {
		private static var nodeArray:Vector.<Node>;
		
		private static const TOUCH_SQUARED:Number = 1000;
		
		public static function Initialize():void {
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
				
				for (var l:int = 0; l < totalChildren; l++) {
					children.push(nodefile.readInt());
				}
				
				nodeArray.push(new Node(x, y, children));
			}
			
			for (var j:int = 0; j < numnodes; j++) {
				for (var k:int = 0; k < nodeArray[j].children.length; k++) {
					nodeArray[nodeArray[j].children[k]].parents.push(j);
				}
			}
		}
		
		public static function NextNode(node:int):int {
			return nodeArray[node].NextChild();
		}
		
		public static function OnlyOneChild(node:int):Boolean {
			return (nodeArray[node].TotalChildren() < 2);
		}
		
		public static function FirstNode(carX:Number, carY:Number):int {
			return 0;
		}
		
		public static function TouchNode(node:int, carX:Number, carY:Number):Boolean {
			if (MathHelper.DistanceSquared(new Point(nodeArray[node].x, nodeArray[node].y), new Point(carX, carY)) < TOUCH_SQUARED) {
				return true;
			}
			
			return false;
		}
		
		public static function GetNode(node:int):Node {
			if(node >= 0 && node < nodeArray.length) {
				return nodeArray[node];
			}
			
			return null;
		}
		
		public static function GetNearestNode(x:Number, y:Number):int {
			var currentNearestIndex:int = 0;
			var currentNearestSqr:Number = Number.MAX_VALUE;
			
			var p:Point = new Point(x, y);
			
			for (var i:int = 0; i < nodeArray.length; i++) {
				var thisDist:Number = MathHelper.DistanceSquared(new Point(nodeArray[i].x, nodeArray[i].y), p);
				
				if (thisDist < currentNearestSqr) {
					currentNearestSqr = thisDist;
					currentNearestIndex = i;
				}
			}
			
			return currentNearestIndex;
		}
	}
}