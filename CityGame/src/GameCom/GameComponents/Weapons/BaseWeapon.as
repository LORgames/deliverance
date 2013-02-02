package GameCom.GameComponents.Weapons {
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Paul
	 */
	public class BaseWeapon extends Sprite {
		public const MACHINE_GUN:int = 0;
		public const ROCKET_POD:int = 1;
		public const LASER:int = 2;
		
		public var WeaponType:int = -1;
		
		private var World:b2World;
		
		public function BaseWeapon(world:b2World) {
			World = world;
		}
		
		public function Fire():void {
			
		}
		
		public function StopFiring():void {
			
		}
		
		public function Update(x:Number, y:Number):void {
			var angle:Number = Math.atan2(y - parent.stage.stageHeight / 2, x - parent.stage.stageWidth / 2);
			this.rotation = angle / Math.PI * 180 - parent.rotation;
		}
	}

}