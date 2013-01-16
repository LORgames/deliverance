package GameCom.Managers {
	import Box2D.Collision.b2AABB;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.GameComponents.ScenicObject
	/**
	 * ...
	 * @author Paul
	 */
	public class ScenicManager {
		
		private var LoadedTypes:Array = new Array();
		private var Objects:Array = new Array();
		
		private var drawList:Array = new Array();
		
		private var layer:Sprite;
		private var player:Sprite;
		private var world:b2World;
		
		public function ScenicManager(worldSpr:Sprite, player:Sprite, world:b2World) {
			this.layer = worldSpr;
			this.player = player;
			this.world = world;
			
			var objectTypes:ByteArray = ThemeManager.Get("1.cache"); //Will be needed for physics
			//TODO: When Physics is implemented, needs to be loaded in here
			
			var objectFile:ByteArray = ThemeManager.Get("1.map");
			
			objectFile.position = 0;
			var totalShapes:int = objectFile.readInt();
			 
			for (var i:int = 0; i < totalShapes; i++) {
				var sourceID:int = objectFile.readInt();
				var locationX:Number = objectFile.readFloat();
				var locationY:Number = objectFile.readFloat();
				var rotation:int = objectFile.readInt();
				
				Objects.push(new ScenicObject(sourceID, locationX, locationY, rotation, world));
			}
		}
		
        public function DrawScenicObjects():void {
            drawList = new Array();
			
			var area:b2AABB = new b2AABB();
			area.lowerBound.Set((player.x - this.layer.stage.stageWidth / 2)/Global.PHYSICS_SCALE, (player.y - this.layer.stage.stageHeight / 2)/Global.PHYSICS_SCALE);
			area.upperBound.Set((player.x + this.layer.stage.stageWidth / 2)/Global.PHYSICS_SCALE, (player.y + this.layer.stage.stageHeight / 2)/Global.PHYSICS_SCALE);
			
            this.world.QueryAABB(QCBD, area);
			
			drawList.sortOn("index");
			
			layer.graphics.clear();
			
			for (var i:int = 0; i < drawList.length; i++) {
                (drawList[i] as ScenicObject).Draw(layer.graphics);
            }
        }

        private function QCBD(fix:b2Fixture):Boolean {
            if (fix.GetUserData() is ScenicObject) {
                drawList.push(fix.GetUserData());
            }
			
            return true;
        }
		
	}

}