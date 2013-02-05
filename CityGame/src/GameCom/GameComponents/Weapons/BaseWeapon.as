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
		public const MACHINE_GUN:int = 0;
		public const ROCKET_POD:int = 1;
		public const LASER:int = 2;
		
		public var WeaponType:int = -1;
		
		protected var World:b2World;
		
		public var IgnoreList:Vector.<b2Fixture> = new Vector.<b2Fixture>();
		
		private var _fireDelay:Number = 0.0;
		
		//Delay between shots in seconds?
		protected var FIRE_RATE:Number = 0.1; //0.2=5APS, 1.0=1APS, 2.0=0.5APS, etc
		
		public function BaseWeapon(world:b2World) {
			World = world;
		}
		
		public function Fire():void {
			
		}
		
		public function Update():void {
			var p:Point = Mousey.GetPosition();
			
			var angle:Number = Math.atan2(p.y - parent.stage.stageHeight / 2, p.x - parent.stage.stageWidth / 2);
			this.rotation = angle / Math.PI * 180 - parent.rotation;
			
			if(_fireDelay < FIRE_RATE) {
				_fireDelay += Global.TIME_STEP;
			}
			
			while (Mousey.IsClicking() && _fireDelay >= FIRE_RATE) {
				_fireDelay -= FIRE_RATE;
				Fire();
			}
		}
	}

}