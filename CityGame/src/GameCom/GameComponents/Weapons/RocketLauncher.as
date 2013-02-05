package GameCom.GameComponents.Weapons 
{
	import Box2D.Dynamics.b2World;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class RocketLauncher extends BaseWeapon {
		
		public function RocketLauncher(world:b2World) {
			super(world);
			
			FIRE_RATE = 2.5;
			
			var cls:Class = ThemeManager.GetClassFromSWF("SWFs/Weapons.swf", "LORgames.Rocket");
			this.addChild(new cls());
		}
		
		override public function Fire():void {
			
		}
		
		override public function Update(p:Point, wantsToFire:Boolean):void {
			super.Update(p, wantsToFire);
			this.rotation = 90;
		}
		
	}

}