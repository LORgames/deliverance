package GameCom.GameComponents {
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.geom.ColorTransform;
	import GameCom.Managers.GUIManager;
	import GameCom.States.GameScreen;
	import LORgames.Engine.Keys;
	import flash.ui.Keyboard;
	import GameCom.Managers.TriggerManager;
	
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Collision.Shapes.*;
	import flash.display.*;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class PlayerTruck extends Sprite {
		private const MAX_STEER_ANGLE:Number = Math.PI/4;
		private const STEER_SPEED:Number = 5.0;
		
		private const SIDEWAYS_FRICTION_FORCE:Number = 1000;
		private const HORSEPOWER_MAX:Number = 50;
		private const HORSEPOWER_INC:Number = 25;
		
		private const NOSFACTOR:Number = 1.5;
		
		private const leftRearWheelPosition:b2Vec2 = new b2Vec2(-1.2, 3.0);
		private const rightRearWheelPosition:b2Vec2 = new b2Vec2(1.2, 3.0);
		private const leftMidWheelPosition:b2Vec2 = new b2Vec2( -1.2, 1.5);
		private const rightMidWheelPosition:b2Vec2 = new b2Vec2( 1.2, 1.5);
		private const leftFrontWheelPosition:b2Vec2 =new b2Vec2(-1.2,-3.0);
		private const rightFrontWheelPosition:b2Vec2= new b2Vec2(1.2,-3.0);
		
		private var engineSpeed:Number = 0;
		private var steeringAngle:Number = 0;
		
		public var body:b2Body;
		private var leftWheel:b2Body;
		private var rightWheel:b2Body;
		private var leftMidWheel:b2Body;
		private var rightMidWheel:b2Body;
		private var leftRearWheel:b2Body;
		private var rightRearWheel:b2Body;
		
		private var leftJoint:b2RevoluteJoint;
		private var rightJoint:b2RevoluteJoint;
		
		public var HealthPercent:Number = 1;
		private var healthMax:Number = 1000;
		private var healthCurrent:Number = 1000;
		
		public function PlayerTruck(spawnPosition:b2Vec2, world:b2World, worldSpr:Sprite) {
			worldSpr.addChild(this);
			
			this.addChild(ThemeManager.Get("TruckBits/Truck.swf"));
			this.getChildAt(0).scaleX = 0.25;
			this.getChildAt(0).scaleY = 0.25;
			
			this.getChildAt(0).x = -this.getChildAt(0).width / 2;
			this.getChildAt(0).y = -this.getChildAt(0).height / 2 - 15;
			
			this.getChildAt(0).transform.colorTransform = new ColorTransform(1.0, 1.0, 1.0);
			
			//Load the trailer
			this.addChild(ThemeManager.Get("TruckBits/trailer.swf"));
			this.getChildAt(1).scaleX = 0.35;
			this.getChildAt(1).scaleY = 0.3;
			
			this.getChildAt(1).x = -this.getChildAt(1).width / 2;
			this.getChildAt(1).y = -this.getChildAt(1).height / 2 + 15;
			
			this.getChildAt(1).transform.colorTransform = new ColorTransform(1.0, 1.0, 0.4);
			
			//////////////////////////
			// TRUCK BODY
			
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsBox(1.2,4.0);
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			bodyFixtureDef.density = 0.2;
			
			//Create the defintion
			var bodyBodyDef:b2BodyDef = new b2BodyDef();
			bodyBodyDef.type = b2Body.b2_dynamicBody;
			bodyBodyDef.linearDamping = 1;
			bodyBodyDef.angularDamping = 1;
			bodyBodyDef.position = spawnPosition.Copy();
			
			//Create the body
			body = world.CreateBody(bodyBodyDef);
			body.CreateFixture(bodyFixtureDef);
			
			///////////////////////////
			// WHEELS
			
			//Wheel shape
			var wheelShape:b2PolygonShape = new b2PolygonShape();
			wheelShape.SetAsBox(0.2,0.5);
			
			//Create the fixture
			var wheelFixtureDef:b2FixtureDef = new b2FixtureDef();
			wheelFixtureDef.shape = wheelShape;
			wheelFixtureDef.density = 1.0;
			
			//Create the defintion
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			wheelBodyDef.type = b2Body.b2_dynamicBody;
			wheelBodyDef.position = spawnPosition.Copy();
			
			//Create the body
			wheelBodyDef.position.Add(leftFrontWheelPosition);
			leftWheel = world.CreateBody(wheelBodyDef);
			leftWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(leftFrontWheelPosition);
			
			wheelBodyDef.position.Add(rightFrontWheelPosition);
			rightWheel = world.CreateBody(wheelBodyDef);
			rightWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(rightFrontWheelPosition);
			
			wheelBodyDef.position.Add(leftMidWheelPosition);
			leftMidWheel = world.CreateBody(wheelBodyDef);
			leftMidWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(leftMidWheelPosition);
			
			wheelBodyDef.position.Add(rightMidWheelPosition);
			rightMidWheel = world.CreateBody(wheelBodyDef);
			rightMidWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(rightMidWheelPosition);
			
			wheelBodyDef.position.Add(leftRearWheelPosition);
			leftRearWheel = world.CreateBody(wheelBodyDef);
			leftRearWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(leftRearWheelPosition);
			
			wheelBodyDef.position.Add(rightRearWheelPosition);
			rightRearWheel = world.CreateBody(wheelBodyDef);
			rightRearWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(rightRearWheelPosition);
			
			//Create the joints 
			var leftJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			leftJointDef.Initialize(body, leftWheel, leftWheel.GetWorldCenter());
			leftJointDef.enableMotor = true;
			leftJointDef.maxMotorTorque = 100;
			 
			var rightJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			rightJointDef.Initialize(body, rightWheel, rightWheel.GetWorldCenter());
			rightJointDef.enableMotor = true;
			rightJointDef.maxMotorTorque = 100;
			 
			leftJoint = b2RevoluteJoint(world.CreateJoint(leftJointDef));
			rightJoint = b2RevoluteJoint(world.CreateJoint(rightJointDef));
			
			var leftMidJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			leftMidJointDef.Initialize(body, leftMidWheel, leftMidWheel.GetWorldCenter(), new b2Vec2(1,0));
			leftMidJointDef.enableLimit = true;
			leftMidJointDef.lowerTranslation = leftMidJointDef.upperTranslation = 0;
			 
			var rightMidJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			rightMidJointDef.Initialize(body, rightMidWheel, rightMidWheel.GetWorldCenter(), new b2Vec2(1,0));
			rightMidJointDef.enableLimit = true;
			rightMidJointDef.lowerTranslation = rightMidJointDef.upperTranslation = 0;
			
			world.CreateJoint(leftMidJointDef);
			world.CreateJoint(rightMidJointDef);
			
			var leftRearJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			leftRearJointDef.Initialize(body, leftRearWheel, leftRearWheel.GetWorldCenter(), new b2Vec2(1,0));
			leftRearJointDef.enableLimit = true;
			leftRearJointDef.lowerTranslation = leftRearJointDef.upperTranslation = 0;
			 
			var rightRearJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			rightRearJointDef.Initialize(body, rightRearWheel, rightRearWheel.GetWorldCenter(), new b2Vec2(1,0));
			rightRearJointDef.enableLimit = true;
			rightRearJointDef.lowerTranslation = rightRearJointDef.upperTranslation = 0;
			 
			world.CreateJoint(leftRearJointDef);
			world.CreateJoint(rightRearJointDef);
		}
		
		private function killOrthogonalVelocity(targetBody:b2Body):void {
			var localPoint:b2Vec2 = new b2Vec2(0, 0);
			
			var velocity:b2Vec2 = targetBody.GetLinearVelocity();
			
			var sidewaysAxis:b2Vec2 = targetBody.GetTransform().R.col2.Copy();
			sidewaysAxis.Multiply(b2Math.Dot(velocity, sidewaysAxis));
			
			targetBody.SetLinearVelocity(sidewaysAxis); //targetBody.GetWorldPoint(localPoint));
			
			var i:Number = targetBody.GetPosition().x * Global.PHYSICS_SCALE - this.x;
			var j:Number = targetBody.GetPosition().y * Global.PHYSICS_SCALE - this.y;
		}
		
		public function Update(dt:Number):void {
			if (Keys.isKeyDown(Keyboard.UP)) {
				if(engineSpeed > -HORSEPOWER_MAX) {
					engineSpeed -= HORSEPOWER_INC*dt;
				}
			} else if (Keys.isKeyDown(Keyboard.DOWN)) {
				if(engineSpeed < HORSEPOWER_MAX) {
					engineSpeed += HORSEPOWER_INC*dt;
				}
			} else {
				engineSpeed = 0;
			}
			
			if(Keys.isKeyDown(Keyboard.RIGHT)) {
				steeringAngle = MAX_STEER_ANGLE
			} else if(Keys.isKeyDown(Keyboard.LEFT)) {
				steeringAngle = -MAX_STEER_ANGLE
			} else {
				steeringAngle = 0;
			}
			
			if (Keys.isKeyDown(Keyboard.SPACE)) {
				steeringAngle *= 0.2;
			}
			
			this.graphics.clear();
			
			if (!Keys.isKeyDown(Keyboard.SHIFT)) {
				killOrthogonalVelocity(leftWheel);
				killOrthogonalVelocity(rightWheel);
				killOrthogonalVelocity(leftRearWheel);
				killOrthogonalVelocity(rightRearWheel);
				killOrthogonalVelocity(leftMidWheel);
				killOrthogonalVelocity(rightMidWheel);
			}
			
			if (Keys.isKeyDown(Keyboard.SPACE)) {
				engineSpeed = -HORSEPOWER_MAX*NOSFACTOR;
			} else if (Math.abs(engineSpeed) > HORSEPOWER_MAX) {
				engineSpeed *= 0.5;
			}
			
			//Driving
			var ldirection:b2Vec2 = leftWheel.GetTransform().R.col2.Copy();
			ldirection.Multiply(engineSpeed);
			
			var rdirection:b2Vec2 = rightWheel.GetTransform().R.col2.Copy()
			rdirection.Multiply(engineSpeed);
			
			leftWheel.ApplyForce(ldirection, leftWheel.GetPosition());
			rightWheel.ApplyForce(rdirection, rightWheel.GetPosition());
			
			//Steering
			var mspeed:Number;
			mspeed = steeringAngle - leftJoint.GetJointAngle();
			leftJoint.SetMotorSpeed(mspeed * STEER_SPEED);
			mspeed = steeringAngle - rightJoint.GetJointAngle();
			rightJoint.SetMotorSpeed(mspeed * STEER_SPEED);
			
			this.x = int(body.GetPosition().x * Global.PHYSICS_SCALE);
			this.y = int(body.GetPosition().y * Global.PHYSICS_SCALE);
			this.rotation = body.GetAngle() / Math.PI * 180;
			
			
			var contacts:b2ContactEdge = body.GetContactList();
			
			while (contacts != null) {
				if (contacts.other.GetUserData() is PlaceObject && contacts.contact.IsTouching()) {
					var place:PlaceObject = contacts.other.GetUserData() as PlaceObject;
					
					if(place.isActive) {
						TriggerManager.ReportTrigger("place_" + place.TriggerValue, place);
					}
				} /*else if (!contacts.contact.IsSensor() && contacts.contact.IsTouching()) {
					var manifold:b2WorldManifold = new b2WorldManifold();
					contacts.contact.GetWorldManifold(manifold);
					
					var vel1:b2Vec2 = this.body.GetLinearVelocityFromWorldPoint(manifold.m_points[0]);
					
					this.graphics.lineStyle(1, 0xFF0000);
					this.graphics.drawCircle(manifold.m_points[0].x * Global.PHYSICS_SCALE - this.x, manifold.m_points[0].y * Global.PHYSICS_SCALE - this.y, vel1.Length());
					
					Damage(vel1.Length());
				}*/
				
				contacts = contacts.next;
			}
		}
		
		public function Damage(damage:int):void {
			damage -= 5; //Just to balance out low impact collisions that are annoying as fuck as a player
			if(damage > 0) {
				trace("HP LOSS: " + damage);
				healthCurrent -= damage;
				HealthPercent = Number(healthCurrent) / healthMax;
				GUIManager.I.UpdateCache();
			}
		}
	}
}