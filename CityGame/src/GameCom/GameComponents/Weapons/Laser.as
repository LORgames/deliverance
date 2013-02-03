package GameCom.GameComponents.Weapons 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import LORgames.Engine.Mousey;
	/**
	 * ...
	 * @author ...
	 */
	public class Laser extends BaseWeapon {
		
		private var fireTimeout:int = 0;
		private var fixtureHit:b2Fixture;
		private var distance:Number;
		
		public function Laser(world:b2World) {
			super(world);
			
			FIRE_RATE = 5.0; //Laser doesn't even use this...
			
			var cls:Class = ThemeManager.GetClassFromSWF("SWFs/Weapons.swf", "LORgames.Laser");
			this.addChild(new cls());
		}
		
		override public function Update():void {
			super.Update();
			
			this.graphics.clear();
			this.graphics.lineStyle(5, 0xFF0000);
			
			if (Mousey.IsClicking()) {
				var mX:Number = parent.x + Mousey.GetPosition().x - parent.stage.stageWidth / 2;
				var mY:Number = parent.y + Mousey.GetPosition().y - parent.stage.stageHeight / 2
				
				var b1:b2Vec2 = new b2Vec2(parent.x / Global.PHYSICS_SCALE, parent.y / Global.PHYSICS_SCALE);
				var b2:b2Vec2 = new b2Vec2(mX / Global.PHYSICS_SCALE, mY / Global.PHYSICS_SCALE);
				
				var d:b2Vec2 = b1.Copy();
				d.Subtract(b2);
				
				var size:Number = d.Length();
				
				fixtureHit = null;
				World.RayCast(Wrappey, b1, b2);
				
				this.graphics.moveTo(0, 0);
				this.graphics.lineTo(size*distance*Global.PHYSICS_SCALE, 0);
			}
		}
		
		private function Wrappey(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number {
			if (fixture.IsSensor() || fixture.GetFilterData().maskBits == 0 || IgnoreList.indexOf(fixture) != -1) {
				return 1.0;
			}
			
			distance = fraction;
			fixtureHit = fixture;
			return fraction;
		}
		
	}

}