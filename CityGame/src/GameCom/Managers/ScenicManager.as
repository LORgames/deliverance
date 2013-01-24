package GameCom.Managers {
	import Box2D.Collision.b2AABB;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.sampler.NewObjectSample;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import GameCom.GameComponents.BaseObject;
	import GameCom.GameComponents.PlaceObject;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.GameComponents.ScenicObject
	import GameCom.SystemComponents.PhysicsShape;
	import GameCom.SystemComponents.ScenicObjectType;
	/**
	 * ...
	 * @author Paul
	 */
	public class ScenicManager {
		private var Types:Vector.<ScenicObjectType> = new Vector.<ScenicObjectType>();
		private var Objects:Vector.<ScenicObject> = new Vector.<ScenicObject>();
		
		private var drawList:Vector.<ScenicObject> = new Vector.<ScenicObject>();
		
		private var layer0:Sprite;
		private var layer1:Sprite;
		
		private var player:Sprite;
		private var world:b2World;
		
		public function ScenicManager(layer0:Sprite, layer1:Sprite, player:Sprite, world:b2World) {
			this.layer0 = layer0;
			this.layer1 = layer1;
			
			this.player = player;
			this.world = world;
			
			var objectTypes:ByteArray = ThemeManager.Get("1.cache"); //Will be needed for physics
			var objectFile:ByteArray = ThemeManager.Get("1.map");
			
			objectTypes.position = 0;
			objectFile.position = 0;
			
			var i:int;
			var j:int;
			var typeID:int;
			
            var totalTypes:int = objectTypes.readInt();
			var totalPhysicsShapes:int = objectTypes.readInt();
			
            for (i = 0; i < totalTypes; i++) {
				var layer:int = objectTypes.readByte();
				
				Types.push(new ScenicObjectType());
				Types[i].Layer = layer;
            }

            for (i = 0; i < totalPhysicsShapes; i++) {
                typeID = objectTypes.readInt();
				var totalPhysics:int = objectTypes.readInt();
				
				Types[typeID].Physics = new PhysicsShape();
				
                for (j = 0; j < totalPhysics; j++) {
                    var shapeType:int = objectTypes.readByte();
					
					var xPos:Number = objectTypes.readFloat();
					var yPos:Number = objectTypes.readFloat();
					var wDim:Number = objectTypes.readFloat();
					var hDim:Number = objectTypes.readFloat();
					
					if (shapeType == 0) { //Rectangle
						Types[typeID].Physics.AddRectangle(xPos, yPos, wDim, hDim);
					} else if (shapeType == 1) { //Circle
						Types[typeID].Physics.AddCircle(xPos, yPos, wDim);
					}
                }
            }
			
			var totalShapes:int = objectFile.readInt();
			 
			for (i = 0; i < totalShapes; i++) {
				var sourceID:int = objectFile.readInt();
				var locationX:Number = objectFile.readFloat();
				var locationY:Number = objectFile.readFloat();
				var rotation:int = objectFile.readInt();
				
				//Objects.push(new ScenicObject(sourceID, locationX, locationY, rotation, world, Types[sourceID]));
			}
		}
		
        public function DrawScenicObjects():void {
            drawList = new Vector.<ScenicObject>();
			PlacesManager.instance.drawList = new Vector.<PlaceObject>();
			
			var area:b2AABB = new b2AABB();
			area.lowerBound.Set((player.x - this.layer0.stage.stageWidth / 2)/Global.PHYSICS_SCALE, (player.y - this.layer0.stage.stageHeight / 2)/Global.PHYSICS_SCALE);
			area.upperBound.Set((player.x + this.layer0.stage.stageWidth / 2)/Global.PHYSICS_SCALE, (player.y + this.layer0.stage.stageHeight / 2)/Global.PHYSICS_SCALE);
			
            this.world.QueryAABB(QCBD, area);
			
			drawList.sort(BaseObject.Compare);
			
			layer0.graphics.clear();
			layer1.graphics.clear();
			
			for (var i:int = 0; i < drawList.length; i++) {
				if((Types[(drawList[i] as ScenicObject).typeID] as ScenicObjectType).Layer == 0) {
					(drawList[i] as ScenicObject).Draw(layer0.graphics);
				} else {
					(drawList[i] as ScenicObject).Draw(layer1.graphics);
				}
            }
        }

        private function QCBD(fix:b2Fixture):Boolean {
            if (fix.GetUserData() is ScenicObject) {
                drawList.push(fix.GetUserData());
            } else if (fix.GetUserData() is PlaceObject) {
				PlacesManager.instance.drawList.push(fix.GetUserData());
            }
			
            return true;
        }
		
	}

}