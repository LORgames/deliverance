package GameCom.SystemComponents {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	/**
	 * ...
	 * @author Paul
	 */
	public class PhysicsShape {
		public static const RECTANGLE:uint = 0;
		public static const CIRCLE:uint = 1;
		public static const TRIANGLE:uint = 2;
		
		private var FixtureList:Array = new Array();
		
		public function PhysicsShape() {
			trace("Created Physics Shape...");
		}
		
		public function GenerateBody(body:b2Body):void {
			for (var i:int = 0; i < FixtureList.length; i++) {
				var bfd:b2FixtureDef = FixtureList[i];
				body.CreateFixture(bfd);
			}
		}
		
		public function AddCircle(x:Number, y:Number, r:Number):void {
			trace("\tLoaded circle: x:" + x + ", y:" + y + ", r:" + r);
			
			var circle:b2CircleShape = new b2CircleShape(r);
			
			//Create the shape
			var bodyShape:b2CircleShape = new b2CircleShape(r);
			bodyShape.SetLocalPosition(new b2Vec2(x, y));
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			
			FixtureList.push(bodyFixtureDef);
		}
		
		public function AddRectangle(x:Number, y:Number, w:Number, h:Number):void {
			trace("\tLoaded rectangle: x:" + x + ", y:" + y + ", w:" + w + ", h:" + h); 
			
			//Create the shape
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsOrientedBox(w / 2, h / 2, new b2Vec2(x, y));
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			
			FixtureList.push(bodyFixtureDef);
		}
		
	}

}