package GameCom.GameComponents.Weapons 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.sampler.NewObjectSample;
	import GameCom.GameComponents.NPCCar;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.Helpers.AudioStore;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Mousey;
	/**
	 * ...
	 * @author ...
	 */
	public class Laser extends BaseWeapon {
		private var fixtureHit:b2Fixture;
		private var distance:Number;
		
		private const LASER_DAMS:int = 13;
		
		private var myLaserSound:SoundChannel;
		
		public function Laser(world:b2World) {
			super(world);
			
			WeaponType = LASER;
			FIRE_RATE = 5.0; //Laser doesn't even use this...
			
			var cls:Class = ThemeManager.GetClassFromSWF("SWFs/Weapons.swf", "LORgames.Laser");
			this.addChild(new cls());
			(this.getChildAt(0) as MovieClip).stop();
		}
		
		override public function Update(p:Point, wantsToFire:Boolean, damageMultipler:Number = 1.0):void {
			super.Update(p, wantsToFire);
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFF0000);
			
			if (wantsToFire) {
				if (myLaserSound == null) {
					myLaserSound = AudioController.PlayLoop(AudioStore.Laser);
				}
				
				var b1:b2Vec2 = new b2Vec2(parent.x / Global.PHYSICS_SCALE, parent.y / Global.PHYSICS_SCALE);
				var b2:b2Vec2 = new b2Vec2(p.x / Global.PHYSICS_SCALE, p.y / Global.PHYSICS_SCALE);
				
				var d:b2Vec2 = b1.Copy();
				d.Subtract(b2);
				
				var size:Number = d.Length();
				
				fixtureHit = null;
				distance = 1.0;
				
				World.RayCast(Wrappey, b1, b2);
				
				if (distance < 1.0) {
					if (fixtureHit.GetUserData() is NPCCar) {
						var car:NPCCar = fixtureHit.GetUserData() as NPCCar;
						car.Damage(LASER_DAMS*damageMultipler);
					} else if (fixtureHit.GetUserData() is PlayerTruck) {
						(fixtureHit.GetUserData() as PlayerTruck).Damage((LASER_DAMS + 7)*damageMultipler); //Because the player damage thing mitigates damage
					}
				}
				
				this.graphics.moveTo(0, 0);
				this.graphics.lineTo(size*distance*Global.PHYSICS_SCALE, 0);
			} else {
				myLaserSound.stop();
				myLaserSound = null;
			}
		}
		
		private function Wrappey(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number {
			if (fixture.IsSensor() || IgnoreList.indexOf(fixture) != -1) {
				return distance;
			}
			
			if(fraction < distance) {
				distance = fraction;
				fixtureHit = fixture;
			}
			
			return distance;
		}
		
	}

}