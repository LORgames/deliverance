package GameCom.GameComponents.Weapons 
{
	import Box2D.Dynamics.b2World;
	/**
	 * ...
	 * @author ...
	 */
	public class MachineGun extends BaseWeapon {
		
		private var fireTimeout:int = 0;
		
		public function MachineGun(world:b2World) {
			super(world);
			var cls:Class = ThemeManager.GetClassFromSWF("SWFs/Weapons.swf", "LORgames.MachineGun");
			this.addChild(new cls());
		}
		
		override public function Update(x:Number, y:Number):void {
			super.Update(x, y);
			
			fireTimeout--;
			
			if(fireTimeout < 0) {
				this.graphics.clear();
			} else {
				fireTimeout--;
			}
		}
		
	}

}