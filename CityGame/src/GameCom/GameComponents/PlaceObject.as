package GameCom.GameComponents  {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import GameCom.Managers.ScenicManager;
	import GameCom.Managers.WorldManager;
	import GameCom.SystemComponents.MissionParameters;
	import GameCom.SystemComponents.ScenicObjectType;
	/**
	 * ...
	 * @author Paul
	 */
	public class PlaceObject extends BaseObject {
		public var typeID:int = 0;
		public var arrayIndex:int = 0;

		public var position:Point;
		
		public var drawX:int = 0;
		public var drawY:int = 0;
		public var drawW:int = 0;
		public var drawH:int = 0;
		public var drawA:int = 0;
		
		public var drawM:Matrix = new Matrix();
		
		public var isActive:Boolean = false;
		public var TriggerValue:String;
		
		public var b_NPC:uint = 0;
		public var b_Resource:uint = 0;
		
        public function PlaceObject(type:int, posX:Number, posY:Number, angle:int, trigger:String, arrayIndex:int) {
            this.typeID = type;
			this.TriggerValue = trigger;
			this.arrayIndex = arrayIndex;
			this.position = new Point(posX, posY);
			
            var radians:Number = 0.0174532925;
			
			var im:BitmapData = ThemeManager.Get("Places/" + type + ".png");
			
			//Create the shape
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			bodyShape.SetAsBox(im.width / 2 / Global.PHYSICS_SCALE, im.height / 2 / Global.PHYSICS_SCALE);
			
			//Create the fixture
			var bodyFixtureDef:b2FixtureDef = new b2FixtureDef();
			bodyFixtureDef.shape = bodyShape;
			bodyFixtureDef.isSensor = true;
			bodyFixtureDef.userData = this;
			bodyFixtureDef.filter.maskBits = 2;
			
			//Create the defintion
			var bodyBodyDef:b2BodyDef = new b2BodyDef();
			bodyBodyDef.type = b2Body.b2_staticBody;
			bodyBodyDef.position.Set(posX / Global.PHYSICS_SCALE, posY / Global.PHYSICS_SCALE);
			bodyBodyDef.angle = angle*radians;
			
			//Create the body
			baseBody = WorldManager.World.CreateBody(bodyBodyDef);
			baseBody.CreateFixture(bodyFixtureDef);
			baseBody.SetUserData(this);
			
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
            buffer.beginBitmapFill(ThemeManager.Get("Places/" + typeID + ".png"), drawM, false);
			buffer.drawRect(drawX, drawY, drawW, drawH);
			buffer.endFill();
        }
	}
}