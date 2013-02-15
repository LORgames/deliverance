package GameCom.GameComponents 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import GameCom.Managers.ScenicManager;
	import GameCom.Managers.WorldManager;
	import GameCom.SystemComponents.ScenicObjectType;
	/**
	 * ...
	 * @author Paul
	 */
	public class ScenicObject extends BaseObject {
		public static const radians:Number = 0.0174532925;
		
		public var typeID:int = 0;
		
		public var position:Point;
		public var rotation:Number;
		
		public var drawX:int = 0;
		public var drawY:int = 0;
		public var drawW:int = 0;
		public var drawH:int = 0;
		public var drawA:int = 0;
		
		public var drawM:Matrix = new Matrix();
		
		private var body:b2Body;
		
		private var im:BitmapData;
		
        public function ScenicObject(type:int, posX:Number, posY:Number, angle:int, sot:ScenicObjectType) {
            this.typeID = type;
			
			this.position = new Point(posX, posY);
			this.rotation = angle;
			
			im = ThemeManager.Get("obj/" + type + ".png");
			
			AddToWorld();
			
			if (sot.Physics != null) {
				sot.Physics.GenerateBody(body, type==50); //50 is hedge, needs to be a sensor
			}
			
			//Fix the position stuffs
			if (angle > 180)
                angle -= 360;
			
            var a_rotationAngle:int = Math.abs(angle);
			
            var dW:Number = im.width;
            var dH:Number = im.height;
			
            if (a_rotationAngle > 90 && a_rotationAngle != 180) a_rotationAngle -= 90;
			
            var dSin:Number = Math.sin(radians*a_rotationAngle);
            var dCos:Number = Math.cos(radians*a_rotationAngle);
			
            if (a_rotationAngle <= 90) {
                drawW = int(dH * dSin + dW * dCos);
                drawH = int(dW * dSin + dH * dCos);
            } else if(angle == 180) {
                drawW = int(im.width);
                drawH = int(im.height);
            } else {
                drawW = int(dW * dSin + dH * dCos);
                drawH = int(dH * dSin + dW * dCos);
            }
			
            drawX = posX - drawW / 2;
            drawY = posY - drawH / 2;
			
			drawM.translate(-im.width / 2, -im.height / 2);
			drawM.rotate(angle * radians);
			drawM.translate(posX, posY);
        }
		
        public override function Draw(buffer:Graphics):void {
            buffer.beginBitmapFill(im, drawM, false);
			buffer.drawRect(drawX, drawY, drawW, drawH);
			buffer.endFill();
        }
		
		public function CleanUp():void {
			body.GetWorld().DestroyBody(body);
		}
		
		public function AddToWorld():void {
			//Create the shape
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsBox(im.width / 2 / Global.PHYSICS_SCALE, im.height / 2 / Global.PHYSICS_SCALE);
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			bodyFixtureDef.isSensor = true;
			bodyFixtureDef.userData = this;
			bodyFixtureDef.filter.categoryBits = 0x0; // This should be a major speedup
			
			//Create the defintion
			var bodyBodyDef:b2BodyDef = new b2BodyDef();
			bodyBodyDef.type = b2Body.b2_staticBody;
			bodyBodyDef.position.Set(position.x / Global.PHYSICS_SCALE, position.y / Global.PHYSICS_SCALE);
			bodyBodyDef.angle = rotation * radians;
			bodyBodyDef.userData = this;
			
			//Create the body
			body = WorldManager.World.CreateBody(bodyBodyDef);
			body.CreateFixture(bodyFixtureDef);
		}
	}
}