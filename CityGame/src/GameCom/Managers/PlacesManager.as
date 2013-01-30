package GameCom.Managers {
	import Box2D.Collision.b2AABB;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import GameCom.GameComponents.BaseObject;
	import GameCom.GameComponents.PickupPlace;
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
		
		public var PickupLocations:Vector.<PickupPlace> = new Vector.<PickupPlace>();
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
			var shopIndex:int = 0;
			
            for (i = 0; i < totalTypes; i++) {
				var triggerNameLength:int = objectTypes.readShort();
				var triggerName:String = objectTypes.readMultiByte(triggerNameLength, "iso-8859-1");
				
				if (triggerName == "Pickup") {
					pickupIndex = i;
				} else if (triggerName == "Deliver") {
					dropatIndex = i;
				} else if (triggerName == "Weapons") {
					shopIndex = i;
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
				
				var po:PlaceObject;
				
				if (sourceID != pickupIndex) {
					po = new PlaceObject(sourceID, locationX, locationY, rotation, world, Types[sourceID]);
				} else {
					po = new PickupPlace(sourceID, locationX, locationY, rotation, world, Types[sourceID]);
				}
			
				Objects.push(po);
				
				if (sourceID == pickupIndex || sourceID == dropatIndex) {
					po.b_Resource = objectFile.readInt();
					po.b_NPC = objectFile.readShort();
				}
				
				if (sourceID == pickupIndex) {
					PickupLocations.push(po);
					po.isActive = true;
				} else if (sourceID == dropatIndex) {
					DropatLocations.push(po);
				} else if (sourceID == shopIndex) {
					po.isActive = true;
				}
			}
		}
		
        public function DrawObjects():void {
            drawList.sort(BaseObject.Compare);
			
			layer.graphics.clear();
			
			for (var i:int = 0; i < drawList.length; i++) {
				if (drawList[i].isActive) {
					drawList[i].Draw(layer.graphics);
				}
            }
        }
	}

}