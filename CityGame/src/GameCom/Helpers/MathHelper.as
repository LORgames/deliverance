package GameCom.Helpers 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class MathHelper {
		
		public static function DistanceSquared(n:Point, p:Point):Number {
			return Square(n.x - p.x) + Square(n.y - p.y);
		}
		
		public static function Distance(n:Point, p:Point):Number {
			return Math.sqrt(DistanceSquared(n, p));
		}
		
		public static function Square(x:Number):Number {
			return x * x
		}
		
		public static function DistanceToLineSquared(p:Point, v:Point, w:Point):Number {
			var l2:Number = DistanceSquared(v, w);
			
			if (l2 == 0) return DistanceSquared(p, v);
			
			var t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
			
			if (t < 0) return DistanceSquared(p, v);
			if (t > 1) return DistanceSquared(p, w);
			
			return DistanceSquared(p, new Point(v.x + t * (w.x - v.x), v.y + t * (w.y - v.y)));
		}
		
		public static function DistanceToLine(p, v, w):Number {
			return Math.sqrt(DistanceToLineSquared(p, v, w));
		}
		
	}

}