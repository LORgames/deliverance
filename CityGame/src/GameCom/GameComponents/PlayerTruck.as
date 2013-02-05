package GameCom.GameComponents {
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import GameCom.GameComponents.Weapons.BaseWeapon;
	import GameCom.GameComponents.Weapons.Laser;
	import GameCom.GameComponents.Weapons.MachineGun;
	import GameCom.GameComponents.Weapons.RocketLauncher;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.MathHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.PlacesManager;
	import GameCom.States.GameScreen;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Mousey;
	import flash.ui.Keyboard;
	import GameCom.Managers.TriggerManager;
	import LORgames.Engine.Storage;
	
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
		private const BASE_HORSEPOWER_MAX:Number = 100;
		private const BASE_HORSEPOWER_INC:Number = 25;
		private const BASE_NOSFACTOR:Number = 1.5;
		private const BASE_HEALTH:int = 500;
		
		private const HORSEPOWER_MAX_PER_LEVEL:Number = 10;
		private const HORSEPOWER_INC_PER_LEVEL:Number = 2.5;
		private const HEALTH_INC_PER_LEVEL:Number = 100;
		private const ARMOUR_INC_PER_LEVEL:Number = 0.09;
		private const NOS_INC_PER_LEVEL:Number = 0.2;
		
		private var speedUpgradeLevel:int = 0;
		private var accelerationUpgradeLevel:int = 0;
		private var healthUpgradeLevel:int = 0;
		private var armourUpgradeLevel:int = 0;
		private var nosUpgradeLevel:int = 0;
		private var healthMax:Number;
		private var healthCurrent:Number;
		
		public var HealthPercent:Number = 1;
		
		private var currentHorsePowerMax:int = 0;
		private var currentHorsePowerInc:int = 0;
		private var currentNOSFactor:int = 0;
		
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
		
		private var Wep:BaseWeapon;
		private var world:b2World;
		
		private var LRotWheel:Sprite = new Sprite();
		private var RRotWheel:Sprite = new Sprite();
		
		private var CurrentLoop:Sound = null;
		private var IdleLoop:Sound = null;
		private var ReversingLoop:Sound = null;
		private var DrivingLoop:Sound = null;
		
		public function PlayerTruck(spawnPosition:b2Vec2, world:b2World, worldSpr:Sprite) {
			worldSpr.addChild(this);
			this.world = world;
			
			this.addChild(ThemeManager.Get("TruckBits/Truck.swf"));
			this.getChildAt(0).scaleX = 0.25;
			this.getChildAt(0).scaleY = 0.25;
			
			(this.getChildAt(0) as MovieClip).stop();
			this.getChildAt(0).x = -this.getChildAt(0).width / 2;
			this.getChildAt(0).y = -this.getChildAt(0).height / 2 - 15;
			
			this.getChildAt(0).transform.colorTransform = new ColorTransform(1.0, 1.0, 1.0);
			
			//Load the trailer
			this.addChild(ThemeManager.Get("TruckBits/trailer.swf"));
			this.getChildAt(1).scaleX = 0.35;
			this.getChildAt(1).scaleY = 0.3;
			
			(this.getChildAt(1) as MovieClip).stop();
			this.getChildAt(1).x = -this.getChildAt(1).width / 2;
			this.getChildAt(1).y = -this.getChildAt(1).height / 2 + 15;
			
			this.getChildAt(1).transform.colorTransform = new ColorTransform(1.0, 1.0, 0.4);
			
			this.addChildAt(LRotWheel, 0);
			this.addChildAt(RRotWheel, 1);
			
			//////////////////////////
			// TRUCK BODY
			
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsBox(1.2, 4.0);
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			bodyFixtureDef.density = 0.2;
			bodyFixtureDef.filter.categoryBits = 3;
			bodyFixtureDef.userData = this;
			
			//Create the defintion
			var bodyBodyDef:b2BodyDef = new b2BodyDef();
			bodyBodyDef.type = b2Body.b2_dynamicBody;
			bodyBodyDef.linearDamping = 2;
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
			wheelFixtureDef.userData = this;
			
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
			
			FixUpgradeValues();
			EquipWeapon("MachineGun");
			
			//DRAW TIRES
			LRotWheel.graphics.beginFill(0x0);
			LRotWheel.graphics.drawRect( -2, -5, 4, 10);
			LRotWheel.graphics.endFill();
			LRotWheel.x = leftFrontWheelPosition.x * Global.PHYSICS_SCALE + 2;
			LRotWheel.y = leftFrontWheelPosition.y * Global.PHYSICS_SCALE;
			
			RRotWheel.graphics.beginFill(0x0);
			RRotWheel.graphics.drawRect( -2, -5, 4, 10);
			RRotWheel.graphics.endFill();
			RRotWheel.x = rightFrontWheelPosition.x * Global.PHYSICS_SCALE - 2;
			RRotWheel.y = rightFrontWheelPosition.y * Global.PHYSICS_SCALE;
			
			AudioController.PlayLoop(AudioStore.TruckIdle);
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
			if (Keys.isKeyDown(Keyboard.UP) || Keys.isKeyDown(Keyboard.W)) {
				if(engineSpeed > -currentHorsePowerMax) {
					engineSpeed -= currentHorsePowerInc*dt;
				}
			} else if (Keys.isKeyDown(Keyboard.DOWN) || Keys.isKeyDown(Keyboard.S)) {
				if(engineSpeed < currentHorsePowerMax) {
					engineSpeed += currentHorsePowerInc*dt;
				}
			} else {
				engineSpeed = 0;
			}
			
			if(Keys.isKeyDown(Keyboard.RIGHT) || Keys.isKeyDown(Keyboard.D)) {
				steeringAngle = MAX_STEER_ANGLE
			} else if(Keys.isKeyDown(Keyboard.LEFT) || Keys.isKeyDown(Keyboard.A)) {
				steeringAngle = -MAX_STEER_ANGLE
			} else {
				steeringAngle = 0;
			}
			
			if (Keys.isKeyDown(Keyboard.SPACE)) {
				steeringAngle *= 0.2;
			}
			
			killOrthogonalVelocity(leftWheel);
			killOrthogonalVelocity(rightWheel);
			killOrthogonalVelocity(leftRearWheel);
			killOrthogonalVelocity(rightRearWheel);
			killOrthogonalVelocity(leftMidWheel);
			killOrthogonalVelocity(rightMidWheel);
			
			if (Keys.isKeyDown(Keyboard.SPACE)) {
				engineSpeed = -currentHorsePowerMax*currentNOSFactor;
			} else if (Math.abs(engineSpeed) > currentHorsePowerMax) {
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
				}
				
				contacts = contacts.next;
			}
			
			LRotWheel.rotation = leftWheel.GetAngle() / Math.PI * 180 - this.rotation;
			RRotWheel.rotation = rightWheel.GetAngle() / Math.PI * 180 - this.rotation;
			
			var mX:Number = x + Mousey.GetPosition().x - parent.stage.stageWidth / 2;
			var mY:Number = y + Mousey.GetPosition().y - parent.stage.stageHeight / 2;
			var p:Point = new Point(mX, mY);
			
			Wep.Update(p, Mousey.IsClicking());
			if (healthCurrent < 0) Respawn();
		}
		
		public function Damage(damage:int):void {
			damage -= 5;
			
			damage *= 1 - (ARMOUR_INC_PER_LEVEL * armourUpgradeLevel);
			
			if(damage > 0) {
				healthCurrent -= damage;
				HealthPercent = Number(healthCurrent) / healthMax;
				GUIManager.I.UpdateCache();
			}
		}
		
		public function FixUpgradeValues():void {
			//////////////////////////
			// LOAD UPGRADES
			speedUpgradeLevel = Storage.GetAsInt("SpeedUpgrade", 0);
			accelerationUpgradeLevel = Storage.GetAsInt("AccelerationUpgrade", 0);
			healthUpgradeLevel = Storage.GetAsInt("HealthUpgrade", 0);
			armourUpgradeLevel = Storage.GetAsInt("ArmourUpgrade", 0);
			nosUpgradeLevel = Storage.GetAsInt("NOSUpgrade", 0);
			
			//Tweak internal values here based on them
			currentHorsePowerMax = BASE_HORSEPOWER_MAX + HORSEPOWER_MAX_PER_LEVEL * speedUpgradeLevel;
			currentHorsePowerInc = BASE_HORSEPOWER_INC + HORSEPOWER_INC_PER_LEVEL * accelerationUpgradeLevel;
			currentNOSFactor = BASE_NOSFACTOR + NOS_INC_PER_LEVEL * nosUpgradeLevel;
			
			healthMax = BASE_HEALTH + HEALTH_INC_PER_LEVEL * healthUpgradeLevel;
			healthCurrent = healthMax;
			HealthPercent = 1;
		}
		
		/**
		 * Locate the nearest spawn point and move the truck there. Reset health to max.
		 */
		public function Respawn():void {
			var closest:PlaceObject = null;
			var closestDist:Number = Number.MAX_VALUE;
			var bodyP:Point = new Point(this.x, this.y);
			
			for (var i:int = 0; i < PlacesManager.instance.SpawnLocations.length; i++) {
				var spawnPoint:PlaceObject = PlacesManager.instance.SpawnLocations[i];
				
				var nPOS:Number = MathHelper.DistanceSquared(bodyP, spawnPoint.position);
				
				if (nPOS < closestDist) {
					closestDist = nPOS;
					closest = spawnPoint;
				}
			}
			
			var offsetX:Number = closest.position.x / Global.PHYSICS_SCALE;
			var offsetY:Number = closest.position.y / Global.PHYSICS_SCALE;
			
			body.SetPosition(new b2Vec2(offsetX, offsetY));
			leftWheel.SetPosition(new b2Vec2(offsetX, offsetY));
			rightWheel.SetPosition(new b2Vec2(offsetX, offsetY));
			leftMidWheel.SetPosition(new b2Vec2(offsetX, offsetY));
			rightMidWheel.SetPosition(new b2Vec2(offsetX, offsetY));
			leftRearWheel.SetPosition(new b2Vec2(offsetX, offsetY));
			rightRearWheel.SetPosition(new b2Vec2(offsetX, offsetY));
			
			body.SetLinearVelocity(new b2Vec2());
			leftWheel.SetLinearVelocity(new b2Vec2());
			rightWheel.SetLinearVelocity(new b2Vec2());
			leftMidWheel.SetLinearVelocity(new b2Vec2());
			rightMidWheel.SetLinearVelocity(new b2Vec2());
			leftRearWheel.SetLinearVelocity(new b2Vec2());
			rightRearWheel.SetLinearVelocity(new b2Vec2());
			
			body.SetAngularVelocity(0);
			leftWheel.SetAngularVelocity(0);
			rightWheel.SetAngularVelocity(0);
			leftMidWheel.SetAngularVelocity(0);
			rightMidWheel.SetAngularVelocity(0);
			leftRearWheel.SetAngularVelocity(0);
			rightRearWheel.SetAngularVelocity(0);
			
			healthCurrent = healthMax;
			HealthPercent = 1.0;
			
			GUIManager.I.UpdateCache();
			GUIManager.I.Update();
		}
		
		public function EquipWeapon(weaponName:String):void {
			if (Wep != null) {
				this.removeChild(Wep);
			}
			
			switch(weaponName) {
				case "MachineGun":
					Wep = new MachineGun(world); break;
				case "RocketPod":
					Wep = new RocketLauncher(world); break;
				case "Laser":
				default:
					Wep = new Laser(world); break;
			}
			
			Wep.IgnoreList.push(body.GetFixtureList());
			Wep.IgnoreList.push(leftRearWheel.GetFixtureList());
			Wep.IgnoreList.push(rightRearWheel.GetFixtureList());
			Wep.IgnoreList.push(leftMidWheel.GetFixtureList());
			Wep.IgnoreList.push(rightMidWheel.GetFixtureList());
			Wep.IgnoreList.push(leftWheel.GetFixtureList());
			Wep.IgnoreList.push(rightWheel.GetFixtureList());
			
			this.addChild(Wep);
		}
	}
}