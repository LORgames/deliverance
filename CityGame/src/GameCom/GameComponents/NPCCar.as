package GameCom.GameComponents 
{
	import flash.geom.ColorTransform;
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
		
		private const MAX_STEER_ANGLE:Number = Math.PI / 5;
		private const STEER_SPEED:Number = 5.0;
		
		private const SIDEWAYS_FRICTION_FORCE:Number = 1000;
		private const HORSEPOWER_MAX:Number = 15;
		private const HORSEPOWER_INC:Number = 5;
		
		private const leftRearWheelPosition:b2Vec2 = new b2Vec2(-1.0, 1.3);
		private const rightRearWheelPosition:b2Vec2 = new b2Vec2(1.0, 1.3);
		private const leftFrontWheelPosition:b2Vec2 =new b2Vec2(-1.0,-1.3);
		private const rightFrontWheelPosition:b2Vec2= new b2Vec2(1.0,-1.3);
		
		private var engineSpeed:Number = 0;
		private var steeringAngle:Number = 0;
		
		private var body:b2Body;
		private var leftWheel:b2Body;
		private var rightWheel:b2Body;
		private var leftRearWheel:b2Body;
		private var rightRearWheel:b2Body;
		
		private var leftJoint:b2RevoluteJoint;
		private var rightJoint:b2RevoluteJoint;
		
		// AI
		private var nodeManager:NodeManager;
		private var targetNode:int = 0;
		
		public function NPCCar(spawnPosition:b2Vec2, world:b2World, nodeManager:NodeManager) {
			this.world = world;
			
			this.nodeManager = nodeManager;
			
			var CarA:Class = ThemeManager.GetClassFromSWF("TruckBits/Basic Car.swf", "LORgames.BasicCar");
			this.addChild(new CarA());
			
			this.getChildAt(0).x = -this.getChildAt(0).width / 2;
			this.getChildAt(0).y = -this.getChildAt(0).height / 2;
			
			(this.getChildAt(0) as MovieClip).getChildAt(0).transform.colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
			
			// Car Body
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsBox(1.0,2.0);
			
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
			
			targetNode = nodeManager.GetNearestNode(spawnPosition.x*Global.PHYSICS_SCALE, spawnPosition.y*Global.PHYSICS_SCALE);
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
				
				// always accelerate toward targetNode
				if(engineSpeed > -HORSEPOWER_MAX) {
					engineSpeed -= HORSEPOWER_INC;
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
				
				(this.parent as Sprite).graphics.lineStyle(1, 0x0000FF);
				(this.parent as Sprite).graphics.moveTo(this.x, this.y);
				(this.parent as Sprite).graphics.lineTo(tNode.x, tNode.y);
				
				(this.parent as Sprite).graphics.lineStyle(1, 0x00FF00);
				(this.parent as Sprite).graphics.moveTo(this.x, this.y);
				(this.parent as Sprite).graphics.lineTo(this.x + Math.cos(angle2) * 10, this.y + Math.sin(angle2) * 10);
				
				(this.parent as Sprite).graphics.lineStyle(1, 0xFF0000);
				(this.parent as Sprite).graphics.moveTo(this.x, this.y);
				(this.parent as Sprite).graphics.lineTo(GUIManager.I.player.x, GUIManager.I.player.y);
			} else {
				targetNode = nodeManager.GetNearestNode(this.x/Global.PHYSICS_SCALE, this.y/Global.PHYSICS_SCALE);
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
		}
	}

}