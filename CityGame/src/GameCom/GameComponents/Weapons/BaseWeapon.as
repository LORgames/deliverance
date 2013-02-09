package GameCom.GameComponents.Weapons {
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.geom.Point;
	import LORgames.Engine.Mousey;
	/**
	 * ...
	 * @author Paul
	 */
	public class BaseWeapon extends Sprite {
		public static const MACHINE_GUN:int = 0;
		public static const ROCKET_POD:int = 1;
		public static const LASER:int = 2;
		
		public var WeaponType:int = -1;
		
		protected var World:b2World;
		
		public var IgnoreList:Vector.<b2Fixture> = new Vector.<b2Fixture>();
		
		private var _fireDelay:Number = 0.0;
		
		//Delay between shots in seconds?
		protected var FIRE_RATE:Number = 0.1; //0.2=5APS, 1.0=1APS, 2.0=0.5APS, etc
		
		protected var p:Point;
		protected var wantsToFire:Boolean;
		
		public function BaseWeapon(world:b2World) {
			World = world;
		}
		
		public static function ConvertTypeToString(type:int):String {
			switch(type) {
				case MACHINE_GUN:
					return "Machine Gun";
				case ROCKET_POD:
					return "Rocket Pod";
				case LASER:
					return "Laser";
				default:
					return null;
			}
		}
		
		public function Fire(damageMultipler:Number = 1.0):void {
			
		}
		
		public function WeaponTypeToString():String {
			switch(WeaponType) {
				case MACHINE_GUN:
					return "Machine Gun";
				case ROCKET_POD:
					return "Rocket Pod";
				case LASER:
					return "Laser";
				default:
					return "";
			}
		}
		
		public function Update(p:Point, wantsToFire:Boolean, damageMultipler:Number = 1.0):void {
			this.p = p;
			this.wantsToFire = wantsToFire;
			
			var angle:Number = Math.atan2(p.y - parent.y, p.x - parent.x);
			this.rotation = angle / Math.PI * 180 - parent.rotation;
			
			if(_fireDelay < FIRE_RATE) {
				_fireDelay += Global.TIME_STEP;
			}
			
			while (wantsToFire && _fireDelay >= FIRE_RATE) {
				_fireDelay -= FIRE_RATE;
				Fire(damageMultipler);
			}
		}
	}

}