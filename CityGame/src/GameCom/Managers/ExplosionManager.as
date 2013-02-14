package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameCom.Helpers.AudioStore;
	import LORgames.Engine.AudioController;
	/**
	 * ...
	 * @author Paul
	 */
	public class ExplosionManager {
		
		public static var I:ExplosionManager;
		
		private var playing_explosions:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var waiting_explosions:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var playing_explosions_lamppost:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var waiting_explosions_lamppost:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var layer0:Sprite;
		private var layer1:Sprite;
		
		public function ExplosionManager(layer0:Sprite, layer1:Sprite):void {
			I = this;
			
			this.layer0 = layer0;
			this.layer1 = layer1;
		}
		
		public function RequestExplosionAt(p:Point):void {
			if (waiting_explosions.length == 0) {
				var cls:Class = ThemeManager.GetClassFromSWF("SWFs/Explosion.swf", "LORgames.explosion");
				var new_explosion:MovieClip = new cls();
				layer0.addChild(new_explosion);
				new_explosion.visible = false;
				
				waiting_explosions.push(new_explosion);
			}
			
			var explosion:MovieClip = waiting_explosions.pop();
			
			explosion.visible = true;
			
			explosion.x = p.x;
			explosion.y = p.y;
			explosion.gotoAndPlay(0);
			
			playing_explosions.push(explosion);
			
			WorldManager.Explode(new b2Vec2(p.x / Global.PHYSICS_SCALE, p.y / Global.PHYSICS_SCALE), 7.5, 300);
			
			AudioController.PlaySound(AudioStore.Explode);
		}
		
		public function RequestDeadLamppostAt(p:Point, r:Number):void {
			if (waiting_explosions_lamppost.length == 0) {
				var cls:Class = ThemeManager.GetClassFromSWF("SWFs/Explosion.swf", "LORgames.LampExplosion");
				
				var new_explosion:MovieClip = new cls();
				layer1.addChild(new_explosion);
				new_explosion.visible = false;
				
				waiting_explosions_lamppost.push(new_explosion);
			}
			
			var explosion:MovieClip = waiting_explosions_lamppost.pop();
			
			explosion.visible = true;
			
			explosion.x = p.x;
			explosion.y = p.y;
			explosion.rotation = r;
			
			explosion.gotoAndPlay(0);
			
			playing_explosions_lamppost.push(explosion);
			
			AudioController.PlaySound(AudioStore.Explode);
		}
		
		public function Update():void {
			var explosion:MovieClip;
			
			if (playing_explosions.length > 0 && playing_explosions[0].currentFrame == playing_explosions[0].totalFrames) {
				explosion = playing_explosions.splice(0, 1)[0];
				
				waiting_explosions.push(explosion);
				explosion.visible = false;
			}
			
			if (playing_explosions_lamppost.length > 0 && playing_explosions_lamppost[0].currentFrame == playing_explosions_lamppost[0].totalFrames) {
				explosion = playing_explosions_lamppost.splice(0, 1)[0];
				
				waiting_explosions_lamppost.push(explosion);
				explosion.visible = false;
			}
		}
		
		
	}

}