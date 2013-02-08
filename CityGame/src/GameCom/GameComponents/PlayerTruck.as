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
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.MissionManager;
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
		private const MAX_STEER_ANGLE:Number = Math.PI / 4;
		
		private const STEER_SPEED:Number = 2.0;
		private const STEERING_CORRECT_SPEED:Number = 5.0;
		
		private const SIDEWAYS_FRICTION_FORCE:Number = 1000;
		private const BASE_HORSEPOWER_MAX:Number = 100;
		private const BASE_HORSEPOWER_INC:Number = 25;
		private const BASE_HEALTH:int = 500;
		private const BASE_REVERSE_SPEED:int = 20;
		
		private const BASE_DAMAGEFACTOR:Number = 1.0;
		
		private const HORSEPOWER_MAX_PER_LEVEL:Number = 10;
		private const HORSEPOWER_INC_PER_LEVEL:Number = 2.5;
		private const HEALTH_INC_PER_LEVEL:Number = 100;
		private const ARMOUR_INC_PER_LEVEL:Number = 0.09;
		private const DAMAGE_INC_PER_LEVEL:Number = 0.2;
		
		private var speedUpgradeLevel:int = 0;
		private var accelerationUpgradeLevel:int = 0;
		private var healthUpgradeLevel:int = 0;
		private var armourUpgradeLevel:int = 0;
		private var damageUpgradeLevel:int = 0;
		private var healthMax:Number;
		private var healthCurrent:Number;
		
		public var HealthPercent:Number = 1;
		
		private var currentHorsePowerMax:int = 0;
		private var currentHorsePowerInc:int = 0;
		private var currentDamageFactor:int = 0;
		
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
		
		private var CurrentLoop:* = null;
		private var IdleLoop:* = null;
		private var ReversingLoop:* = null;
		private var DrivingLoop:* = null;
		
		public var Colours:Vector.<ColorTransform> = new Vector.<ColorTransform>();
		
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
			EquipWeapon(BaseWeapon.ConvertTypeToString(Storage.GetAsInt("CurrentWeapon", -1)));
			
			Colours.push(new ColorTransform(238/255, 223/255, 221/255),
						 new ColorTransform(104/255, 102/255, 089/255),
						 new ColorTransform(225/255, 206/255, 041/255),
						 new ColorTransform(063/255, 096/255, 239/255),
						 new ColorTransform(180/255, 059/255, 037/255),
						 new ColorTransform(221/255, 140/255, 211/255),
						 new ColorTransform(121/255, 042/255, 157/255),
						 new ColorTransform(072/255, 147/255, 062/255),
						 new ColorTransform(233/255, 162/255, 061/255),
						 new ColorTransform(099/255, 181/255, 198/255));
			
			if (Storage.GetAsInt("CColour", -1) != -1) {
				this.getChildAt(2).transform.colorTransform = Colours[Storage.GetAsInt("CColour", -1)];
			}
			
			if (Storage.GetAsInt("TColour", -1) != -1) {
				this.getChildAt(3).transform.colorTransform = Colours[Storage.GetAsInt("TColour", -1)];
			}
			
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
			
			IdleLoop = AudioController.PlayLoop(AudioStore.TruckIdle);
			ReversingLoop = AudioController.PlayLoop(AudioStore.TruckReverse, false);
			DrivingLoop = AudioController.PlayLoop(AudioStore.TruckDriving, false);
			CurrentLoop = IdleLoop;
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
				if (CurrentLoop != DrivingLoop) {
					AudioController.PlaySound(AudioStore.TruckTakeoff);
					AudioController.FadeOut(CurrentLoop);
					AudioController.FadeIn(DrivingLoop);
					CurrentLoop = DrivingLoop;
				}
				
				if(engineSpeed > -currentHorsePowerMax) {
					engineSpeed -= currentHorsePowerInc*dt;
				}
			} else if (Keys.isKeyDown(Keyboard.DOWN) || Keys.isKeyDown(Keyboard.S)) {
				if (CurrentLoop != ReversingLoop) {
					AudioController.FadeOut(CurrentLoop);
					AudioController.FadeIn(ReversingLoop);
					CurrentLoop = ReversingLoop;
				}
				
				if(engineSpeed < BASE_REVERSE_SPEED) {
					engineSpeed += currentHorsePowerInc*dt;
				}
			} else {
				if (CurrentLoop != IdleLoop) {
					AudioController.FadeOut(CurrentLoop);
					AudioController.FadeIn(IdleLoop);
					CurrentLoop = IdleLoop;
				}
				
				engineSpeed = 0;
			}
			
			if(Keys.isKeyDown(Keyboard.RIGHT) || Keys.isKeyDown(Keyboard.D)) {
				steeringAngle = MAX_STEER_ANGLE;
			} else if(Keys.isKeyDown(Keyboard.LEFT) || Keys.isKeyDown(Keyboard.A)) {
				steeringAngle = -MAX_STEER_ANGLE;
			} else {
				steeringAngle = 0;
			}
			
			killOrthogonalVelocity(leftWheel);
			killOrthogonalVelocity(rightWheel);
			killOrthogonalVelocity(leftRearWheel);
			killOrthogonalVelocity(rightRearWheel);
			killOrthogonalVelocity(leftMidWheel);
			killOrthogonalVelocity(rightMidWheel);
			
			if (Math.abs(engineSpeed) > currentHorsePowerMax) {
				engineSpeed *= 0.75;
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
			leftJoint.SetMotorSpeed(mspeed * (steeringAngle==0?STEERING_CORRECT_SPEED:STEER_SPEED));
			
			mspeed = steeringAngle - rightJoint.GetJointAngle();
			rightJoint.SetMotorSpeed(mspeed * (steeringAngle==0?STEERING_CORRECT_SPEED:STEER_SPEED));
			
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
			
			if (Wep != null)
				Wep.Update(p, Mousey.IsClicking(), currentDamageFactor);
			
			if (healthCurrent < 0) Respawn(true);
		}
		
		public function Damage(damage:int):void {
			damage -= 10;
			
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
			damageUpgradeLevel = Storage.GetAsInt("DamageUpgrade", 0);
			
			//Tweak internal values here based on them
			currentHorsePowerMax = BASE_HORSEPOWER_MAX + HORSEPOWER_MAX_PER_LEVEL * speedUpgradeLevel;
			currentHorsePowerInc = BASE_HORSEPOWER_INC + HORSEPOWER_INC_PER_LEVEL * accelerationUpgradeLevel;
			currentDamageFactor = BASE_DAMAGEFACTOR + DAMAGE_INC_PER_LEVEL * damageUpgradeLevel;
			
			healthMax = BASE_HEALTH + HEALTH_INC_PER_LEVEL * healthUpgradeLevel;
			healthCurrent = healthMax;
			HealthPercent = 1;
		}
		
		/**
		 * Locate the nearest spawn point and move the truck there. Reset health to max.
		 */
		public function Respawn(becauseOfDamage:Boolean = false):void {
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
			
			if (becauseOfDamage) {
				var money:int = MoneyHelper.GetBalance();
				MoneyHelper.Debit(money / 5);
				
				if(MissionManager.CancelMission()) {
					GUIManager.I.Popup("I'll repair your truck. It'll cost $" + Math.floor(money / 5) + " for parts and labor and your current mission will be cancelled.\nRemember to purchase armour and health upgrades at a garage!", 0, 0, true);
				} else {
					GUIManager.I.Popup("I'll repair your truck. It'll cost $" + Math.floor(money / 5) + " for parts and labor.\nRemember to purchase armour and health upgrades at a garage!", 0, 0, true);
				}
			}
			
			GUIManager.I.UpdateCache();
			GUIManager.I.Update();
		}
		
		public function EquipWeapon(weaponName:String):void {
			if (Wep != null) {
				this.removeChild(Wep);
			}
			
			switch(weaponName) {
				case "Machine Gun":
					Wep = new MachineGun(world); break;
				case "Rocket Pod":
					Wep = new RocketLauncher(world); break;
				case "Laser":
					Wep = new Laser(world); break;
				default:
					break;
			}
			
			if (Wep == null) {
				Storage.Set("CurrentWeapon", -1);
			} else {
				Storage.Set("CurrentWeapon", Wep.WeaponType);
				
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
		
		public function GetWeapon():String {
			if (Wep == null) {
				return null;
			} else {
				return Wep.WeaponTypeToString();
			}
		}
	}
}