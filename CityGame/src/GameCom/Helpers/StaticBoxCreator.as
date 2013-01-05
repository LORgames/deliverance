package GameCom.Helpers {
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.Shapes.*;
	/**
	 * ...
	 * @author Paul
	 */
	public class StaticBoxCreator {
		
		public static const BOX_SIZE:Number = 30;
		public static const HALF_BOX:Number = BOX_SIZE / 2;
		
		public static function CreateBoxes(world:b2World) : void {
			//Wheel shape
			var wheelShape:b2PolygonShape = new b2PolygonShape();
			wheelShape.SetAsBox(HALF_BOX,0.1);
			
			//Create the fixture
			var wheelFixtureDef:b2FixtureDef = new b2FixtureDef();
			wheelFixtureDef.shape = wheelShape;
			wheelFixtureDef.density = 1.0;
			
			//Create the defintion
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			wheelBodyDef.type = b2Body.b2_staticBody;
			
			//Create the body
			wheelBodyDef.position = new b2Vec2(HALF_BOX, 0);
			var leftWheel:b2Body = world.CreateBody(wheelBodyDef);
			leftWheel.CreateFixture(wheelFixtureDef);
			
			wheelBodyDef.position = new b2Vec2(HALF_BOX, BOX_SIZE);
			var lWheel:b2Body = world.CreateBody(wheelBodyDef);
			lWheel.CreateFixture(wheelFixtureDef);
			
			wheelBodyDef.position = new b2Vec2(0, HALF_BOX);
			var lrWheel:b2Body = world.CreateBody(wheelBodyDef);
			lrWheel.CreateFixture(wheelFixtureDef);
			lrWheel.SetAngle(3.14 / 2);
			
			wheelBodyDef.position = new b2Vec2(BOX_SIZE, HALF_BOX);
			var lrfheel:b2Body = world.CreateBody(wheelBodyDef);
			lrfheel.CreateFixture(wheelFixtureDef);
			lrfheel.SetAngle(3.14 / 2);
		}
		
	}

}