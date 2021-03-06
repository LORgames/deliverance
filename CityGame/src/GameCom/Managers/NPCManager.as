package GameCom.Managers 
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameCom.GameComponents.NPCCar;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.Helpers.MathHelper;
	
	
	/**
	 * ...
	 * @author Miles
	 */
	
	public class NPCManager {
		private var player:PlayerTruck;
		private var world:b2World;
		private var worldSpr:Sprite;
		private var stage:DisplayObject;
		
		private var maxCars:int = 10;
		private var carSpawnChance:Number = 0.75;
		private var cars:Vector.<NPCCar> = new Vector.<NPCCar>();
		
		private const STAGE_OFFSET:int = 300;
		
		private var area:b2AABB = new b2AABB();
		private var safeToSpawn:Boolean = true;
		
		private var nodeManager:NodeManager;
		
		public static var I:NPCManager;
		
		public function NPCManager(player:PlayerTruck, worldSpr:Sprite) {
			if (I != null) {
				I.DestroyAllCars();
			}
			
			I = this;
			
			this.player = player;
			this.world = world;
			this.worldSpr = worldSpr;
			this.stage = stage;
			
			nodeManager = new NodeManager();
		}
		
		public function GetNPCByName(name:String):NPCCar {
			for each (var car:NPCCar in cars) {
				if (car.name == name) {
					return car;
				}
			}
			return null;
		}
		
		public function Update(dt:Number):void {
			if (worldSpr.stage == null) {
				DestroyAllCars();
				return;
			}
			
			var fullRect:Rectangle = new Rectangle(player.x - (worldSpr.stage.stageWidth) / 2 - STAGE_OFFSET, player.y - worldSpr.stage.stageHeight / 2 - STAGE_OFFSET, worldSpr.stage.stageWidth + STAGE_OFFSET * 2, worldSpr.stage.stageHeight + STAGE_OFFSET * 2);
			var screenRect:Rectangle = new Rectangle(player.x - (worldSpr.stage.stageWidth) / 2, player.y - worldSpr.stage.stageHeight / 2, worldSpr.stage.stageWidth, worldSpr.stage.stageHeight);
			
			if ((cars.length < maxCars) && (Math.random() < carSpawnChance)) {
				var plrVelocity:b2Vec2 = player.body.GetLinearVelocity();
				
				var randomPositionX:Number = fullRect.x + fullRect.width * Math.random();
				var randomPositionY:Number = fullRect.y + fullRect.height * Math.random();
				
				var spawnPoint:Point = new Point(randomPositionX, randomPositionY);
				
				var nodeID:int = NodeManager.GetNearestNode(randomPositionX, randomPositionY);
				var nextNode:int = NodeManager.NextNode(nodeID);
				
				var a:Point = NodeManager.GetNode(nodeID).p;
				var b:Point = NodeManager.GetNode(nextNode).p;
				
				spawnPoint = MathHelper.NearestPointOnLine(spawnPoint, a, b);
				
				safeToSpawn = true;
				
				area.lowerBound = new b2Vec2(spawnPoint.x / Global.PHYSICS_SCALE - 2, spawnPoint.y / Global.PHYSICS_SCALE - 2);
				area.upperBound = new b2Vec2(spawnPoint.x / Global.PHYSICS_SCALE + 2, spawnPoint.y / Global.PHYSICS_SCALE + 2);
				
				WorldManager.World.QueryAABB(HasWorldPhysicsThing, area);
				
				if (safeToSpawn && !screenRect.containsPoint(spawnPoint)) {
					var angle:Number = MathHelper.GetAngleBetween(a, b);
					
					cars.push(new NPCCar(new b2Vec2(spawnPoint.x/Global.PHYSICS_SCALE, spawnPoint.y/Global.PHYSICS_SCALE), angle, nextNode));
					worldSpr.addChild(cars[cars.length - 1]);
				}
			}
			
			for (var i:int = 0; i < cars.length; ) {
				var car:NPCCar = cars[i];
				car.Update(dt);
				
				// if car not visible destroy
				var carRect:Rectangle = new Rectangle(car.x - car.width / 2, car.y - car.height / 2, car.width, car.height);
				
				if (!fullRect.intersects(carRect)) {
					car.Destroy();
					worldSpr.removeChild(cars[i]);
					cars.splice(i, 1);
				} else {
					i++;
				}
			}
		}
		
		public function DestroyAllCars():void {
			while (cars.length > 0) {
				var car:NPCCar = cars.pop();
				
				car.Destroy();
				worldSpr.removeChild(car);
			}
		}
		
		public function DestroyMe(car:NPCCar):void {
			car.Destroy();
			worldSpr.removeChild(car);
			
			for (var i:int = 0; i < cars.length; i++) {
				if (cars[i] == car) {
					cars.splice(i, 1);
				}
			}
		}
		
		private function HasWorldPhysicsThing(fixture:b2Fixture):Boolean {
			if (fixture.IsSensor()) {
				return true;
			}
			
			safeToSpawn = false;
			return false;
		}
	}

}