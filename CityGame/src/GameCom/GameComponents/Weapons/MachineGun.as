package GameCom.GameComponents.Weapons 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import GameCom.GameComponents.NPCCar;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.MathHelper;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Mousey;
	/**
	 * ...
	 * @author ...
	 */
	public class MachineGun extends BaseWeapon {
		private var fixtureHit:b2Fixture;
		private var distance:Number;
		
		public function MachineGun(world:b2World) {
			super(world);
			
			FIRE_RATE = 0.1;
			
			var cls:Class = ThemeManager.GetClassFromSWF("SWFs/Weapons.swf", "LORgames.MachineGun");
			this.addChild(new cls());
		}
		
		override public function Fire():void {
			AudioController.PlaySound(AudioStore.MachineGunBullet);
			
			var mX:Number = parent.x + Mousey.GetPosition().x - parent.stage.stageWidth / 2;
			var mY:Number = parent.y + Mousey.GetPosition().y - parent.stage.stageHeight / 2;
			
			var b1:b2Vec2 = new b2Vec2(parent.x / Global.PHYSICS_SCALE, parent.y / Global.PHYSICS_SCALE);
			var b2:b2Vec2 = new b2Vec2(mX / Global.PHYSICS_SCALE, mY / Global.PHYSICS_SCALE);
			
			var d:b2Vec2 = b2.Copy();
			d.Subtract(b1);
			
			var angleBecauseInaccurate:Number = (-5 + Math.random() * 10) / 180 * Math.PI;
			
			var b3:b2Vec2 = MathHelper.RotateVector(d, angleBecauseInaccurate);
			
			b3.Add(b1);
			
			var size:Number = d.Length();
			
			fixtureHit = null;
			distance = 1.0;
			
			World.RayCast(Wrappey, b1, b3);
			
			if (distance < 1.0) {
				if (fixtureHit.GetUserData() is NPCCar) {
					var car:NPCCar = fixtureHit.GetUserData() as NPCCar;
					(car.getChildAt(0) as MovieClip).getChildAt(0).transform.colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
				}
			}
			
			this.graphics.lineStyle(1, 0xFF9C00, 0.7);
			this.graphics.lineGradientStyle(GradientType.RADIAL, [0xFFFF00, 0xFF9C00, 0xFF0000], [0.2, 0.5, 0.8], [0, 50, 255]);
			
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(Math.cos(angleBecauseInaccurate)*size*distance*Global.PHYSICS_SCALE, Math.sin(angleBecauseInaccurate)*size*distance*Global.PHYSICS_SCALE);
		}
		
		override public function Update():void {
			this.graphics.clear();
			
			super.Update();
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