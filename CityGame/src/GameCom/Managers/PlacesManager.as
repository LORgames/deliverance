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
	import LORgames.Engine.Storage;
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
		public var SpawnLocations:Vector.<PlaceObject> = new Vector.<PlaceObject>();
		public var CollectableLocations:Vector.<PlaceObject> = new Vector.<PlaceObject>();
		
		public var DeliveryLocationsByResource:Vector.<Vector.<PlaceObject>> = new Vector.<Vector.<PlaceObject>>();
		
		private var layer:Sprite;
		
		private var player:Sprite;
		private var world:b2World;
		
		public function PlacesManager(layer0:Sprite, player:Sprite, world:b2World) {
			if (instance != null) {
				//We've already loaded this before
				return;
			}
			
			var i:int;
			var j:int;
			var typeID:int;
			
			//Need to add a delivery location vector for every resource
			for (i = 0; i < 32; i++) {
				DeliveryLocationsByResource.push(new Vector.<PlaceObject>());
			}
			
			instance = this;
			
			this.layer = layer0;
			
			this.player = player;
			this.world = world;
			
			var objectTypes:ByteArray = ThemeManager.Get("3.cache"); //Will be needed for physics
			var objectFile:ByteArray = ThemeManager.Get("3.map");
			
			objectTypes.position = 0;
			objectFile.position = 0;
			
            var totalTypes:int = objectTypes.readInt();
			
			var pickupIndex:int = 0;
			var dropatIndex:int = 0;
			var shopIndex:int = 0;
			var spawnIndex:int = 0;
			var collectableIndex:int = 0;
			
            for (i = 0; i < totalTypes; i++) {
				var triggerNameLength:int = objectTypes.readShort();
				var triggerName:String = objectTypes.readMultiByte(triggerNameLength, "iso-8859-1");
				
				if (triggerName == "Pickup") {
					pickupIndex = i;
				} else if (triggerName == "Deliver") {
					dropatIndex = i;
				} else if (triggerName == "Weapons") {
					shopIndex = i;
				} else if (triggerName == "SpawnPoint") {
					spawnIndex = i;
				} else if (triggerName == "Collectable") {
					collectableIndex = i;
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
				
				if (sourceID == pickupIndex) {
					po = new PickupPlace(sourceID, locationX, locationY, rotation, world, Types[sourceID], PickupLocations.length);
					
					po.b_Resource = objectFile.readInt();
					po.b_NPC = objectFile.readShort();
					
					PickupLocations.push(po);
				} else if (sourceID == dropatIndex) {
					po = new PlaceObject(sourceID, locationX, locationY, rotation, world, Types[sourceID], DropatLocations.length);
					
					po.b_Resource = objectFile.readInt();
					po.b_NPC = objectFile.readShort();
					
					for (j = 0; j < 32; j++) {
						if (((0x1 << j) & po.b_Resource) > 0) {
							DeliveryLocationsByResource[j].push(po);
						}
					}
					
					DropatLocations.push(po);
				} else if (sourceID == shopIndex) {
					po = new PlaceObject(sourceID, locationX, locationY, rotation, world, Types[sourceID], 0);
					po.isActive = true;
				} else if (sourceID == collectableIndex) {
					po = new PlaceObject(sourceID, locationX, locationY, rotation, world, Types[sourceID], 0);
					
					if (!Storage.GetAsBool("Collectable_" + CollectableLocations.length)) {
						po.isActive = true;
					}
					
					CollectableLocations.push(po);
				} else if (sourceID == spawnIndex) {
					po = new PlaceObject(sourceID, locationX, locationY, rotation, world, Types[sourceID], 0);
					po.isActive = false;
					
					SpawnLocations.push(po);
				}
				
				Objects.push(po);
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