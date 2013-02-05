package GameCom.Helpers {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Paul
	 */
	public class WorldPhysicsLoader {
		
		public static function InjectPhysicsIntoWorld(world:b2World):void {
			var bDef:b2BodyDef = new b2BodyDef();
			bDef.type = b2Body.b2_staticBody;
			
			var body:b2Body = world.CreateBody(bDef);
			
			//Read in the file :)
			var objectTypes:ByteArray = ThemeManager.Get("WorldPhysics.bin"); //Will be needed for physics
			objectTypes.position = 0;
			var totalPhysicsShapes:int = objectTypes.readInt();
			
			for (var i:int = 0; i < totalPhysicsShapes; i++) {
                var shapeType:int = objectTypes.readInt();
				
				var xPos:Number = objectTypes.readFloat() / Global.PHYSICS_SCALE;
				var yPos:Number = objectTypes.readFloat() / Global.PHYSICS_SCALE;
				var wDim:Number = objectTypes.readFloat() / Global.PHYSICS_SCALE;
				var hDim:Number = 0;
				
				if (shapeType == 0) { //Rectangle
					hDim = objectTypes.readFloat() / Global.PHYSICS_SCALE;
					body.CreateFixture(AddRectangle(xPos, yPos, wDim, hDim));
				} else if (shapeType == 1) { //Circle
					body.CreateFixture(AddCircle(xPos, yPos, wDim));
				} else if (shapeType == 2) { //Edge
					hDim = objectTypes.readFloat() / Global.PHYSICS_SCALE;
					body.CreateFixture(AddEdge(xPos, yPos, wDim, hDim));
				}
            }
		}
		
		private static function AddCircle(x:Number, y:Number, r:Number):b2FixtureDef {
			var circle:b2CircleShape = new b2CircleShape(r);
			
			//Create the shape
			var bodyShape:b2CircleShape = new b2CircleShape(r);
			bodyShape.SetLocalPosition(new b2Vec2(x, y));
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			
			return bodyFixtureDef;
		}
		
		private static function AddRectangle(x:Number, y:Number, w:Number, h:Number):b2FixtureDef {
			//Create the shape
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsOrientedBox(w, h, new b2Vec2(x, y));
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			
			return bodyFixtureDef;
		}
		
		private static function AddEdge(p0x:Number, p0y:Number, p1x:Number, p1y:Number):b2FixtureDef {
			//Create the shape
			var bodyShape:b2PolygonShape = b2PolygonShape.AsEdge(new b2Vec2(p0x, p0y), new b2Vec2(p1x, p1y));
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			
			return bodyFixtureDef;
		}
		
	}

}