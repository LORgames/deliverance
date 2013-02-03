package GameCom.GameComponents.Projectiles 
{
	import flash.display.Graphics;
	import GameCom.GameComponents.Weapons.BaseWeapon;
	/**
	 * ...
	 * @author Paul
	 */
	public class BaseProjectile {
		
		public var firingSystem:BaseWeapon;
		
		public function BaseProjectile(weapon:BaseWeapon) {
			firingSystem = weapon;
		}
		
		public function Update(gfx:Graphics):void {
			
		}
		
	}

}