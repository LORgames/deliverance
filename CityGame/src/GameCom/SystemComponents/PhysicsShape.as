package GameCom.SystemComponents {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2EdgeShape;
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
		public static const EDGE:uint = 3;
		
		private var FixtureList:Array = new Array();
		
		public function PhysicsShape() {
			//Not sure if anything needs to be done here.
		}
		
		public function GenerateBody(body:b2Body, isSensor:Boolean = false):void {
			for (var i:int = 0; i < FixtureList.length; i++) {
				var bfd:b2FixtureDef = FixtureList[i];
				bfd.isSensor = isSensor;
				
				body.CreateFixture(bfd);
			}
		}
		
		public function AddCircle(x:Number, y:Number, r:Number):void {
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
			//Create the shape
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsOrientedBox(w, h, new b2Vec2(x, y));
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			
			FixtureList.push(bodyFixtureDef);
		}
		
		public function AddEdge(p0x:Number, p0y:Number, p1x:Number, p1y:Number):void {
			//Create the shape
			var bodyShape:b2PolygonShape = b2PolygonShape.AsEdge(new b2Vec2(p0x, p0y), new b2Vec2(p1x, p1y));
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			
			FixtureList.push(bodyFixtureDef);
		}
		
		public function IsEmpty():Boolean {
			return (FixtureList.length == 0);
		}
		
	}

}