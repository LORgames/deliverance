package GameCom.Managers {
	import Box2D.Collision.b2AABB;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
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
	public class PlacesManager {
		public static var instance:PlacesManager;
		
		private var Types:Vector.<String> = new Vector.<String>();
		private var Objects:Vector.<PlaceObject> = new Vector.<PlaceObject>();
		
		public var drawList:Vector.<PlaceObject> = new Vector.<PlaceObject>();
		
		public var PickupLocations:Vector.<PlaceObject> = new Vector.<PlaceObject>();
		public var DropatLocations:Vector.<PlaceObject> = new Vector.<PlaceObject>();
		
		private var layer:Sprite;
		
		private var player:Sprite;
		private var world:b2World;
		
		public function PlacesManager(layer0:Sprite, player:Sprite, world:b2World) {
			if (instance != null) {
				//We've already loaded this before
				return;
			}
			
			instance = this;
			
			this.layer = layer0;
			
			this.player = player;
			this.world = world;
			
			var objectTypes:ByteArray = ThemeManager.Get("3.cache"); //Will be needed for physics
			var objectFile:ByteArray = ThemeManager.Get("3.map");
			
			objectTypes.position = 0;
			objectFile.position = 0;
			
			var i:int;
			var j:int;
			var typeID:int;
			
            var totalTypes:int = objectTypes.readInt();
			
			var pickupIndex:int = 0;
			var dropatIndex:int = 0;
			
            for (i = 0; i < totalTypes; i++) {
				var triggerNameLength:int = objectTypes.readShort();
				var triggerName:String = objectTypes.readMultiByte(triggerNameLength, "iso-8859-1");
				
				if (triggerName == "Pickup") {
					pickupIndex = i;
				} else if (triggerName == "Deliver") {
					dropatIndex = i;
				}
				
				Types.push();
				Types[i] = triggerName;
            }
			
			var totalShapes:int = objectFile.readInt();
			
			for (i = 0; i < totalShapes; i++) {
				var sourceID:int = objectFile.readInt();
				var locationX:Number = objectFile.readFloat();
				var locationY:Number = objectFile.readFloat();
				var rotation:int = objectFile.readInt();
				
				var po:PlaceObject = new PlaceObject(sourceID, locationX, locationY, rotation, world, Types[sourceID]);
				Objects.push(po);
				
				if (sourceID == pickupIndex) {
					PickupLocations.push(po);
					po.isActive = true;
				} else if (sourceID == dropatIndex) {
					DropatLocations.push(po);
				}
			}
		}
		
        public function DrawObjects():void {
            drawList = new Vector.<PlaceObject>();
			
			var area:b2AABB = new b2AABB();
			area.lowerBound.Set((player.x - this.layer.stage.stageWidth / 2)/Global.PHYSICS_SCALE, (player.y - this.layer.stage.stageHeight / 2)/Global.PHYSICS_SCALE);
			area.upperBound.Set((player.x + this.layer.stage.stageWidth / 2)/Global.PHYSICS_SCALE, (player.y + this.layer.stage.stageHeight / 2)/Global.PHYSICS_SCALE);
			
            this.world.QueryAABB(QCBD, area);
			
			drawList.sort(BaseObject.Compare);
			
			layer.graphics.clear();
			
			for (var i:int = 0; i < drawList.length; i++) {
				(drawList[i] as PlaceObject).Draw(layer.graphics);
            }
        }

        private function QCBD(fix:b2Fixture):Boolean {
            if (fix.GetUserData() is PlaceObject) {
				if ((fix.GetUserData() as PlaceObject).isActive) {
					drawList.push(fix.GetUserData());
				}
            }
			
            return true;
        }
	}

}