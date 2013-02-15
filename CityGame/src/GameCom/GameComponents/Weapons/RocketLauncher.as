package GameCom.GameComponents.Weapons 
{
	import Box2D.Dynamics.b2World;
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class RocketLauncher extends BaseWeapon {
		
		public function RocketLauncher() {
			WeaponType = ROCKET_POD;
			FIRE_RATE = 2.5;
			
			var cls:Class = ThemeManager.GetClassFromSWF("SWFs/Weapons.swf", "LORgames.Rocket");
			this.addChild(new cls());
			(this.getChildAt(0) as MovieClip).stop();
		}
		
		override public function Fire(damageMultipler:Number = 1.0):void {
			
		}
		
		override public function Update(p:Point, wantsToFire:Boolean, dt:Number, damageMultipler:Number):void {
			super.Update(p, wantsToFire, dt, damageMultipler);
			this.rotation = 90;
		}
		
	}

}