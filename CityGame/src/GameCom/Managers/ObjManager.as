package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import GameCom.GameComponents.NPCCar;
	import GameCom.GameComponents.PlayerTruck;
	
	
	/**
	 * ...
	 * @author Miles
	 */
	
	public class ObjManager {
		private var player:PlayerTruck;
		private var world:b2World;
		private var worldSpr:Sprite;
		private var stage:DisplayObject;
		
		private var maxCars:int = 1;
		private var carSpawnChance:Number = 0.05;
		private var cars:Vector.<NPCCar> = new Vector.<NPCCar>();
		
		private var nodeManager:NodeManager;
		
		public function ObjManager(player:PlayerTruck, world:b2World, worldSpr:Sprite) {
			this.player = player;
			this.world = world;
			this.worldSpr = worldSpr;
			this.stage = stage;
			
			nodeManager = new NodeManager();
		}
		
		public function Update():void {
			if ((cars.length < maxCars) && (Math.random() < carSpawnChance)) {
				cars.push(new NPCCar(new b2Vec2((player.x + (Math.random() - 0.5) * 400) / Global.PHYSICS_SCALE, (player.y + (Math.random() - 0.5) * 400) / Global.PHYSICS_SCALE), world, nodeManager));
				worldSpr.addChild(cars[cars.length - 1]);
			}
			
			var stageRect:Rectangle = new Rectangle( -worldSpr.x - 40, -worldSpr.y - 40, worldSpr.stage.stageWidth + 80, worldSpr.stage.stageHeight + 80);
			
			for (var i:int = 0; i < cars.length; ) {
				var car:NPCCar = cars[i];
				car.Update();
				
				// if car not visible destroy
				var carRect:Rectangle = new Rectangle(car.x - car.width / 2, car.y - car.height / 2, car.width, car.height);
				
				if (!stageRect.containsRect(carRect)) {
					car.Destroy();
					worldSpr.removeChild(cars[i]);
					cars.splice(i, 1);
				} else {
					i++;
				}
			}
		}
	}

}