package GameCom.GameComponents 
{
	import flash.geom.ColorTransform;
	import GameCom.Helpers.MathHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.NodeManager;
	import GameCom.States.GameScreen;
	import LORgames.Engine.Keys;
	import flash.ui.Keyboard;
	
	import Box2D.Collision.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Collision.Shapes.*;
	import flash.display.*;
	
	/**
	 * ...
	 * @author Miles
	 */
	
	public class NPCCar extends Sprite {
		private var world:b2World;
		
		private const MAX_STEER_ANGLE:Number = Math.PI / 6;
		private const STEER_SPEED:Number = 5.0;
		
		private const SIDEWAYS_FRICTION_FORCE:Number = 1000;
		private const BRAKE_FORCE:Number = 10;
		
		private const HORSEPOWER_MAX:Number = 15;
		private const HORSEPOWER_INC:Number = 5;
		
		private const _leftRearWheelPosition:b2Vec2 = new b2Vec2(-1.0, 1.4);
		private const _rightRearWheelPosition:b2Vec2 = new b2Vec2(1.0, 1.4);
		private const _leftFrontWheelPosition:b2Vec2 = new b2Vec2(-1.0,-1.4);
		private const _rightFrontWheelPosition:b2Vec2 = new b2Vec2(1.0,-1.4);
		
		private var engineSpeed:Number = 0;
		private var steeringAngle:Number = 0;
		
		private var body:b2Body;
		private var leftWheel:b2Body;
		private var rightWheel:b2Body;
		private var leftRearWheel:b2Body;
		private var rightRearWheel:b2Body;
		
		// collision scanner
		private var collisionScanner:b2Body;
		public var collisions:int;
		
		private var leftJoint:b2RevoluteJoint;
		private var rightJoint:b2RevoluteJoint;
		
		// AI
		private var nodeManager:NodeManager;
		private var targetNode:int = 0;
		
		public function NPCCar(spawnPosition:b2Vec2, world:b2World, nodeManager:NodeManager, angle:Number, firstNodeID:int) {
			this.world = world;
			
			var leftRearWheelPosition:b2Vec2 = MathHelper.RotateVector(_leftRearWheelPosition, angle - Math.PI / 2);
			var rightRearWheelPosition:b2Vec2 = MathHelper.RotateVector(_rightRearWheelPosition, angle - Math.PI / 2);
			var leftFrontWheelPosition:b2Vec2 = MathHelper.RotateVector(_leftFrontWheelPosition, angle - Math.PI / 2);
			var rightFrontWheelPosition:b2Vec2= MathHelper.RotateVector(_rightFrontWheelPosition, angle - Math.PI / 2);
			
			this.nodeManager = nodeManager;
			
			var CarA:Class = ThemeManager.GetClassFromSWF("SWFs/Cars.swf", "LORgames.CarA");
			this.addChild(new CarA());
			
			//this.getChildAt(0).x = -this.getChildAt(0).width / 2;
			//this.getChildAt(0).y = -this.getChildAt(0).height / 2;
			
			(this.getChildAt(0) as MovieClip).getChildAt(0).transform.colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
			
			// Car Body
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsBox(1.0,2.2);
			
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
			bodyBodyDef.userData = this.name;
			
			//Angle the car body so it spawns good angles
			bodyBodyDef.angle = angle - Math.PI / 2;
			
			//Create the body
			body = world.CreateBody(bodyBodyDef);
			body.CreateFixture(bodyFixtureDef);
			// Car Wheels
			
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
			wheelBodyDef.angle = angle - Math.PI / 2;
			wheelBodyDef.userData = this.name;
			
			//Create the body
			wheelBodyDef.position.Add(leftFrontWheelPosition);
			leftWheel = world.CreateBody(wheelBodyDef);
			leftWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(leftFrontWheelPosition);
			
			wheelBodyDef.position.Add(rightFrontWheelPosition);
			rightWheel = world.CreateBody(wheelBodyDef);
			rightWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(rightFrontWheelPosition);
			
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
			
			engineSpeed *= (MAX_STEER_ANGLE-Math.abs(steeringAngle)) / (3 * MAX_STEER_ANGLE) + 0.333;
			
			killOrthogonalVelocity(leftWheel);
			killOrthogonalVelocity(rightWheel);
			killOrthogonalVelocity(leftRearWheel);
			killOrthogonalVelocity(rightRearWheel);
			
			// Collision scanner
			var scannerShape:b2PolygonShape = new b2PolygonShape();
			scannerShape.SetAsBox(2.5, 1.0);
			
			var scannerFixtureDef:b2FixtureDef = new b2FixtureDef();
			scannerFixtureDef.shape = scannerShape;
			scannerFixtureDef.density = 0.2;
			scannerFixtureDef.isSensor = true;
			scannerFixtureDef.userData = "collisionScanner";
			scannerFixtureDef.filter.groupIndex = -3;
			
			var scannerBodyDef:b2BodyDef = new b2BodyDef();
			scannerBodyDef.type = b2Body.b2_dynamicBody;
			scannerBodyDef.linearDamping = 1.0;
			scannerBodyDef.angularDamping = 1.0;
			scannerBodyDef.position = spawnPosition.Copy();
			scannerBodyDef.position.Add(MathHelper.RotateVector(new b2Vec2(-2.5,0.0), angle));
			scannerBodyDef.userData = this.name;
			scannerBodyDef.angle = angle;
			
			collisionScanner = world.CreateBody(scannerBodyDef);
			collisionScanner.CreateFixture(scannerFixtureDef);
			
			var scannerJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			scannerJointDef.Initialize(body, collisionScanner, collisionScanner.GetWorldCenter());
			scannerJointDef.enableLimit = true;
			
			world.CreateJoint(scannerJointDef);
			
			collisions = 0;
			
			//Driving
			var ldirection:b2Vec2 = leftWheel.GetTransform().R.col2.Copy();
			ldirection.Multiply(HORSEPOWER_MAX*-10);
			
			var rdirection:b2Vec2 = rightWheel.GetTransform().R.col2.Copy()
			rdirection.Multiply(HORSEPOWER_MAX*-10);
			
			leftWheel.ApplyForce(ldirection, leftWheel.GetPosition());
			rightWheel.ApplyForce(rdirection, rightWheel.GetPosition());
			
			targetNode = firstNodeID;
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
		
		public function Update():void {
			if (targetNode != -1) {
				// if within reach of targetNode then choose next node
				if (nodeManager.TouchNode(targetNode, x, y)) {
					targetNode = nodeManager.NextNode(targetNode);
					if (targetNode == -1) return;
				}
				
				var tNode:Node = nodeManager.GetNode(targetNode);
				
				// always accelerate toward targetNode UNLESS ABOUT TO COLLIDE OMFG JUST LIKE JACOB'S DRIVING 
				if (collisions > 0) {
					engineSpeed = 0;
					body.SetLinearDamping(BRAKE_FORCE);
				} else {
					body.SetLinearDamping(1.0);
					if(engineSpeed > -HORSEPOWER_MAX) {
						engineSpeed -= HORSEPOWER_INC;
					}
				}
				
				// find angle to targetNode and steer towards
				var angle1:Number = Math.atan2(tNode.y - this.y, tNode.x - this.x); //Desired Angle
				
				//steeringAngle = angleDifference;
				var angle2:Number = body.GetAngle() - Math.PI/2; //Body Angle
				
				while (angle1 < 0) angle1 += Math.PI * 2;				
				while (angle1 >= 2*Math.PI) angle1 -= Math.PI * 2;
				
				while (angle2 < 0) angle2 += Math.PI * 2;
				while (angle2 >= 2*Math.PI) angle2 -= Math.PI * 2;
				
				var change:Number = angle2 - angle1;
				while (change > Math.PI) change -= Math.PI * 2;
				while (change < -Math.PI) change += Math.PI * 2;
				
				if (change < 0) {
					steeringAngle = Math.min(MAX_STEER_ANGLE, Math.abs(change)); //Pos?
				} else if (change > 0) {
					steeringAngle = -Math.min(MAX_STEER_ANGLE, Math.abs(change)); //Neg
				} else {
					steeringAngle = 0;
				}
			} else {
				engineSpeed = 0;
				steeringAngle = 0;
			}
			
			engineSpeed *= (MAX_STEER_ANGLE-Math.abs(steeringAngle)) / (3 * MAX_STEER_ANGLE) + 0.333;
			
			killOrthogonalVelocity(leftWheel);
			killOrthogonalVelocity(rightWheel);
			killOrthogonalVelocity(leftRearWheel);
			killOrthogonalVelocity(rightRearWheel);
			
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
			
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			this.rotation = body.GetAngle() * 180 / Math.PI;
		}
		
		public function Destroy():void {
			world.DestroyBody(body);
			world.DestroyBody(leftWheel);
			world.DestroyBody(rightWheel);
			world.DestroyBody(leftRearWheel);
			world.DestroyBody(rightRearWheel);
			world.DestroyBody(collisionScanner);
		}
	}

}