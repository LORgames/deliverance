package GameCom.GameComponents 
{
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.sampler.StackFrame;
	import GameCom.GameComponents.Weapons.BaseWeapon;
	import GameCom.GameComponents.Weapons.Laser;
	import GameCom.GameComponents.Weapons.MachineGun;
	import GameCom.GameComponents.Weapons.RocketLauncher;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.MathHelper;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.MissionManager;
	import GameCom.Managers.NodeManager;
	import GameCom.Managers.NPCManager;
	import GameCom.Managers.WorldManager;
	import GameCom.States.GameScreen;
	import GameCom.SystemComponents.Stat;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Mousey;
	import flash.ui.Keyboard;
	import LORgames.Engine.Stats;
	
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
		private const MAX_STEER_ANGLE:Number = Math.PI / 5;
		private const STEER_SPEED:Number = 20.0;
		
		private const SIDEWAYS_FRICTION_FORCE:Number = 1000;
		private const BRAKE_FORCE:Number = 9;
		
		private const HORSEPOWER_MAX:Number = 12;
		private const HORSEPOWER_INC:Number = 5;
		
		private const NPC_HP:int = 100;
		
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
		
		private var LRotWheel:Sprite = new Sprite();
		private var RRotWheel:Sprite = new Sprite();
		
		// collision scanner
		private var collisionScanner:b2Body;
		public var collisions:int;
		
		private var leftJoint:b2RevoluteJoint;
		private var rightJoint:b2RevoluteJoint;
		
		private var myHP:int = NPC_HP;
		
		// Driving info
		private var previousTargetNode:int = -1;
		private var currentTargetNode:int = 0;
		private var nextTargetNode:int = 0;
		
		private var needToIndicate:Boolean = false;
		private var leftIndicate:Boolean = false;
		
		//Car details
		private var type:int = VEHICLE_CARA;
		private const VEHICLE_DEAD:int = -1;
		private const VEHICLE_CARA:int = 0;
		private const VEHICLE_SPORTSCAR:int = 1;
		private const VEHICLE_ENEMYVAN:int = 2;
		
		public var Wep:BaseWeapon;
		private var ct:ColorTransform = new ColorTransform(Math.random()*0.9 + 0.1, Math.random()*0.9 + 0.1, Math.random()*0.9 + 0.1);
		
		private static var CURRENT_ENEMIES:int = 0;
		
		public function NPCCar(spawnPosition:b2Vec2, angle:Number, firstNodeID:int) {
			var leftRearWheelPosition:b2Vec2 = MathHelper.RotateVector(_leftRearWheelPosition, angle - Math.PI / 2);
			var rightRearWheelPosition:b2Vec2 = MathHelper.RotateVector(_rightRearWheelPosition, angle - Math.PI / 2);
			var leftFrontWheelPosition:b2Vec2 = MathHelper.RotateVector(_leftFrontWheelPosition, angle - Math.PI / 2);
			var rightFrontWheelPosition:b2Vec2= MathHelper.RotateVector(_rightFrontWheelPosition, angle - Math.PI / 2);
			
			var carChance:Number = Math.random();
			var vehicle:Class;
			
			if (CURRENT_ENEMIES < MissionManager.CurrentAllowedEnemies()) {
				vehicle = ThemeManager.GetClassFromSWF("SWFs/Cars.swf", "LORgames.EnemyVan"); // EnemyVan
				type = VEHICLE_ENEMYVAN;
				CURRENT_ENEMIES++;
			} else if (carChance < 0.9) {
				vehicle = ThemeManager.GetClassFromSWF("SWFs/Cars.swf", "LORgames.BasicCar"); // CarA
				type = VEHICLE_CARA;
			} else {
				vehicle = ThemeManager.GetClassFromSWF("SWFs/Cars.swf", "LORgames.SportsCar"); // SportsCar
				type = VEHICLE_SPORTSCAR;
			}
			
			this.addChild(new vehicle());
			(this.getChildAt(0) as MovieClip).stop();
			
			//Turn off lights
			(this.getChildAt(0) as MovieClip).getChildAt(1).visible = false; //LEFT INDICATOR
			(this.getChildAt(0) as MovieClip).getChildAt(2).visible = false; //RIGHT INDICATOR
			(this.getChildAt(0) as MovieClip).getChildAt(3).visible = false; //BRAKE LIGHT 1
			(this.getChildAt(0) as MovieClip).getChildAt(4).visible = false; //BRAKE LIGHT 2
			
			if(type != VEHICLE_ENEMYVAN) {
				(this.getChildAt(0) as MovieClip).getChildAt(0).transform.colorTransform = ct;
			}
			
			// Car Body
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsBox(1.0,2.2);
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			bodyFixtureDef.density = 0.2;
			bodyFixtureDef.userData = this;
			
			//Create the defintion
			var bodyBodyDef:b2BodyDef = new b2BodyDef();
			bodyBodyDef.type = b2Body.b2_dynamicBody;
			bodyBodyDef.linearDamping = 1;
			bodyBodyDef.angularDamping = 1;
			bodyBodyDef.position = spawnPosition.Copy();
			bodyBodyDef.userData = this;
			
			//Angle the car body so it spawns good angles
			bodyBodyDef.angle = angle - Math.PI / 2;
			
			//Create the body
			body = WorldManager.World.CreateBody(bodyBodyDef);
			body.CreateFixture(bodyFixtureDef);
			// Car Wheels
			
			//Wheel shape
			var wheelShape:b2PolygonShape = new b2PolygonShape();
			wheelShape.SetAsBox(0.2,0.5);
			
			//Create the fixture
			var wheelFixtureDef:b2FixtureDef = new b2FixtureDef();
			wheelFixtureDef.shape = wheelShape;
			wheelFixtureDef.density = 1.0;
			wheelFixtureDef.userData = this;
			
			//Create the defintion
			var wheelBodyDef:b2BodyDef = new b2BodyDef();
			wheelBodyDef.type = b2Body.b2_dynamicBody;
			wheelBodyDef.position = spawnPosition.Copy();
			wheelBodyDef.angle = angle - Math.PI / 2;
			
			//Create the body
			wheelBodyDef.position.Add(leftFrontWheelPosition);
			leftWheel = WorldManager.World.CreateBody(wheelBodyDef);
			leftWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(leftFrontWheelPosition);
			
			wheelBodyDef.position.Add(rightFrontWheelPosition);
			rightWheel = WorldManager.World.CreateBody(wheelBodyDef);
			rightWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(rightFrontWheelPosition);
			
			wheelBodyDef.position.Add(leftRearWheelPosition);
			leftRearWheel = WorldManager.World.CreateBody(wheelBodyDef);
			leftRearWheel.CreateFixture(wheelFixtureDef);
			wheelBodyDef.position.Subtract(leftRearWheelPosition);
			
			wheelBodyDef.position.Add(rightRearWheelPosition);
			rightRearWheel = WorldManager.World.CreateBody(wheelBodyDef);
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
			 
			leftJoint = b2RevoluteJoint(WorldManager.World.CreateJoint(leftJointDef));
			rightJoint = b2RevoluteJoint(WorldManager.World.CreateJoint(rightJointDef));
			
			var leftRearJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			leftRearJointDef.Initialize(body, leftRearWheel, leftRearWheel.GetWorldCenter(), new b2Vec2(1,0));
			leftRearJointDef.enableLimit = true;
			leftRearJointDef.lowerTranslation = leftRearJointDef.upperTranslation = 0;
			 
			var rightRearJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			rightRearJointDef.Initialize(body, rightRearWheel, rightRearWheel.GetWorldCenter(), new b2Vec2(1,0));
			rightRearJointDef.enableLimit = true;
			rightRearJointDef.lowerTranslation = rightRearJointDef.upperTranslation = 0;
			
			WorldManager.World.CreateJoint(leftRearJointDef);
			WorldManager.World.CreateJoint(rightRearJointDef);
			
			engineSpeed *= (MAX_STEER_ANGLE-Math.abs(steeringAngle)) / (4 * MAX_STEER_ANGLE) + 0.25;
			
			killOrthogonalVelocity(leftWheel);
			killOrthogonalVelocity(rightWheel);
			killOrthogonalVelocity(leftRearWheel);
			killOrthogonalVelocity(rightRearWheel);
			
			// Collision scanner
			var scannerShape:b2PolygonShape = new b2PolygonShape();
			
			/*var verts:Array = new Array(new b2Vec2( 0.0,-0.5),
										new b2Vec2(-7.0,-1.2),
										new b2Vec2(-7.0, 1.2),
										new b2Vec2( 0.0, 0.5));*/
										
			var verts:Array = new Array(new b2Vec2( 1.4,-1.4),
										new b2Vec2(-5.6,-2.1),
										new b2Vec2(-5.6, 0.1),
										new b2Vec2( 1.4,-0.4));
			
			scannerShape.SetAsArray(verts, 4);
			
			var scannerFixtureDef:b2FixtureDef = new b2FixtureDef();
			scannerFixtureDef.shape = scannerShape;
			scannerFixtureDef.density = 0.2;
			scannerFixtureDef.isSensor = true;
			scannerFixtureDef.userData = this;
			scannerFixtureDef.filter.groupIndex = -3;
			
			var scannerBodyDef:b2BodyDef = new b2BodyDef();
			scannerBodyDef.type = b2Body.b2_dynamicBody;
			scannerBodyDef.linearDamping = 1.0;
			scannerBodyDef.angularDamping = 1.0;
			scannerBodyDef.position = spawnPosition.Copy();
			scannerBodyDef.position.Add(MathHelper.RotateVector(new b2Vec2(-3.0,0.0), angle));
			scannerBodyDef.userData = "collisionScanner";
			scannerBodyDef.angle = angle;
			
			collisionScanner = WorldManager.World.CreateBody(scannerBodyDef);
			collisionScanner.CreateFixture(scannerFixtureDef);
			
			collisions = 0;
			
			//Driving
			var ldirection:b2Vec2 = leftWheel.GetTransform().R.col2.Copy();
			ldirection.Multiply(HORSEPOWER_MAX*-10);
			
			var rdirection:b2Vec2 = rightWheel.GetTransform().R.col2.Copy();
			rdirection.Multiply(HORSEPOWER_MAX*-10);
			
			leftWheel.ApplyForce(ldirection, leftWheel.GetPosition());
			rightWheel.ApplyForce(rdirection, rightWheel.GetPosition());
			
			currentTargetNode = firstNodeID;
			
			//DRAW TIRES
			LRotWheel.graphics.beginFill(0x0);
			LRotWheel.graphics.drawRect(-2, -5, 4, 10);
			LRotWheel.graphics.endFill();
			LRotWheel.x = _leftFrontWheelPosition.x * Global.PHYSICS_SCALE;
			LRotWheel.y = _leftFrontWheelPosition.y * Global.PHYSICS_SCALE;
			this.addChildAt(LRotWheel, 0);
			
			RRotWheel.graphics.beginFill(0x0);
			RRotWheel.graphics.drawRect(-2, -5, 4, 10);
			RRotWheel.graphics.endFill();
			RRotWheel.x = _rightFrontWheelPosition.x * Global.PHYSICS_SCALE;
			RRotWheel.y = _rightFrontWheelPosition.y * Global.PHYSICS_SCALE;
			this.addChildAt(RRotWheel, 1);
			
			//Enemy Constructor Logic
			if (type == VEHICLE_ENEMYVAN) {
				var n:Number = Math.random();
				
				if(n > 0.9 && ReputationHelper.GetCurrentLevel() > 15) {
					EquipWeapon("Laser");
				} else {
					EquipWeapon("MachineGun");
				}
			}
			
			UpdateNodes(false);
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
			var showBrakeLights:Boolean = false;
			
			if (type == VEHICLE_DEAD) {
				this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
				this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
				this.rotation = body.GetAngle() * 180 / Math.PI;
				return;
			}
			
			if (currentTargetNode != -1) {
				// if within reach of targetNode then choose next node
				if (NodeManager.TouchNode(currentTargetNode, x, y)) {
					UpdateNodes();
				}
				
				var tNode:Node = NodeManager.GetNode(currentTargetNode);
				
				// always accelerate toward targetNode UNLESS ABOUT TO COLLIDE OMFG JUST LIKE JACOB'S DRIVING 
				if (collisions > 0) {
					engineSpeed = 0;
					body.SetLinearDamping(BRAKE_FORCE);
					
					if (Math.random() < 0.001) {
						AudioController.PlaySound(AudioStore.Horn);
					}
					
					showBrakeLights = true;
				} else {
					body.SetLinearDamping(1.0);
					if(engineSpeed > -HORSEPOWER_MAX) {
						engineSpeed -= HORSEPOWER_INC;
						
						if (engineSpeed > -HORSEPOWER_MAX) {
							engineSpeed = -HORSEPOWER_MAX;
						}
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
			
			if (Wep != null) {
				var playerDist:Number = MathHelper.Distance(new Point(this.x, this.y), new Point(GUIManager.I.player.x, GUIManager.I.player.y));
				if (playerDist < 300) {
					Wep.Update(new Point(GUIManager.I.player.x, GUIManager.I.player.y), true, dt, 1.0);
				} else {
					Wep.Update(new Point(GUIManager.I.player.x, GUIManager.I.player.y), false, dt, 1.0);
				}
			}
			
			engineSpeed *= (MAX_STEER_ANGLE-Math.abs(steeringAngle)) / (2 * MAX_STEER_ANGLE) + 0.5;
			
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
			
			collisionScanner.SetPositionAndAngle(leftWheel.GetPosition(), leftWheel.GetAngle() + Math.PI/2);
			
			LRotWheel.rotation = leftWheel.GetAngle() / Math.PI * 180 - this.rotation;
			RRotWheel.rotation = rightWheel.GetAngle() / Math.PI * 180 - this.rotation;
			
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			this.rotation = body.GetAngle() * 180 / Math.PI;
			
			(this.getChildAt(2) as MovieClip).getChildAt(3).visible = showBrakeLights; //BRAKE LIGHT 1
			(this.getChildAt(2) as MovieClip).getChildAt(4).visible = showBrakeLights; //BRAKE LIGHT 2
		}
		
		private function UpdateNodes(progressing:Boolean = true):void {
			if(progressing) {
				previousTargetNode = currentTargetNode;
				currentTargetNode = nextTargetNode;
			}
			
			nextTargetNode = NodeManager.NextNode(currentTargetNode);
			
			needToIndicate = !NodeManager.OnlyOneChild(currentTargetNode);
			
			(this.getChildAt(2) as MovieClip).getChildAt(1).visible = false; //RIGHT INDICATOR
			(this.getChildAt(2) as MovieClip).getChildAt(2).visible = false; //LEFT INDICATOR
			
			if (needToIndicate) {
				//figure out which way to indicate
				var angle1:Number = MathHelper.GetAngleBetween(NodeManager.GetNode(currentTargetNode).p, NodeManager.GetNode(nextTargetNode).p);
				var angle2:Number;
				
				if (previousTargetNode == -1) {
					angle2 = body.GetAngle() - Math.PI/2;
				} else { 
					angle2 = MathHelper.GetAngleBetween(NodeManager.GetNode(previousTargetNode).p, NodeManager.GetNode(currentTargetNode).p);
				}
				
				while (angle1 < 0) angle1 += Math.PI * 2;				
				while (angle1 >= 2*Math.PI) angle1 -= Math.PI * 2;
				
				while (angle2 < 0) angle2 += Math.PI * 2;
				while (angle2 >= 2*Math.PI) angle2 -= Math.PI * 2;
				
				var change:Number = angle2 - angle1;
				while (change > Math.PI) change -= Math.PI * 2;
				while (change < -Math.PI) change += Math.PI * 2;
					
				if (change > 0.1) {
					leftIndicate = false;
					//(this.getChildAt(2) as MovieClip).getChildAt(1).visible = true; //RIGHT INDICATOR
				} else if (change < -0.1) {
					leftIndicate = true;
					//(this.getChildAt(2) as MovieClip).getChildAt(2).visible = true; //LEFT INDICATOR
				} else {
					needToIndicate = false;
				}
			}
			
			if (currentTargetNode == -1) return;
		}
		
		public function EquipWeapon(weaponName:String):void {
			if (Wep != null) {
				this.removeChild(Wep);
			}
			
			switch(weaponName) {
				case "MachineGun":
					Wep = new  MachineGun(); break;
				case "Laser":
					Wep = new Laser(); break;
				default:
					Wep = new MachineGun(); break;
			}
			
			Wep.IgnoreList.push(body.GetFixtureList());
			Wep.IgnoreList.push(leftRearWheel.GetFixtureList());
			Wep.IgnoreList.push(rightRearWheel.GetFixtureList());
			Wep.IgnoreList.push(leftWheel.GetFixtureList());
			Wep.IgnoreList.push(rightWheel.GetFixtureList());
			
			this.addChild(Wep);
		}
		
		public function Destroy():void {
			if (type == VEHICLE_ENEMYVAN) {
				CURRENT_ENEMIES--;
			}
			
			WorldManager.World.DestroyBody(body);
			WorldManager.World.DestroyBody(leftWheel);
			WorldManager.World.DestroyBody(rightWheel);
			WorldManager.World.DestroyBody(leftRearWheel);
			WorldManager.World.DestroyBody(rightRearWheel);
			WorldManager.World.DestroyBody(collisionScanner);
		}
		
		public function Damage(dams:int):void {
			myHP -= dams;
			AudioController.PlaySound(AudioStore.NPCHit);
			
			if (type == VEHICLE_DEAD) {
				if (myHP <= 0) {
					ExplosionManager.I.RequestExplosionAt(new Point(this.x, this.y));
					NPCManager.I.DestroyMe(this);
				}
				
				return;
			}
			
			if (myHP <= 0) {
				Stats.AddOne(Stat.TOTAL_CARS_WRECKED);
				
				var cls:Class;
				
				if (type != VEHICLE_ENEMYVAN) {
					this.removeChildAt(2);
					
					cls = ThemeManager.GetClassFromSWF("SWFs/Cars.swf", "LORgames.DeadCar");
					this.addChildAt(new cls(), 2);
					this.getChildAt(2).transform.colorTransform = ct;
				} else {
					Stats.AddOne(Stat.TOTAL_ENEMIES_WRECKED);
					
					CURRENT_ENEMIES--;
					this.removeChildAt(2);
					
					cls = ThemeManager.GetClassFromSWF("SWFs/Cars.swf", "LORgames.DeadEnemyCar");
					this.addChildAt(new cls(), 2);
					
					Wep.Update(new Point(GUIManager.I.player.x, GUIManager.I.player.y), false, 0, 0);
					
					MoneyHelper.Credit(250);
				}
				
				body.SetLinearDamping(5);
				body.SetAngularDamping(5);
				
				type = VEHICLE_DEAD;
				
				myHP = 100;
			}
		}
	}

}