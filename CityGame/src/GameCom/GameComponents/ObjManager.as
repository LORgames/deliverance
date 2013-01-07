package GameCom.GameComponents 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	/**
	 * ...
	 * @author Miles
	 */
	
	public class ObjManager 
	{
		private var player:PlayerTruck;
		private var world:b2World;
		private var worldSpr:Sprite;
		private var stage:DisplayObject;
		
		private var maxCars:int = 5;
		private var carSpawnChance:Number = 0.05;
		private var cars:Array = new Array();
		
		public function ObjManager(player:PlayerTruck, world:b2World, worldSpr:Sprite) 
		{
			this.player = player;
			this.world = world;
			this.worldSpr = worldSpr;
			this.stage = stage;
		}
		
		public function Update():void
		{
			if ((cars.length < maxCars) && (Math.random() < carSpawnChance))
				cars.push(new NPCCar(new b2Vec2((player.x + (Math.random() - 0.5) * 400) / Global.PHYSICS_SCALE, (player.y + (Math.random() - 0.5) * 400) / Global.PHYSICS_SCALE), world, worldSpr));
				
			var i:int = 0;
			var stageRect:Rectangle = new Rectangle( -worldSpr.x - 40, -worldSpr.y - 40, worldSpr.stage.stageWidth + 80, worldSpr.stage.stageHeight + 80);
			
			for each (var car:NPCCar in cars)
			{
				car.Update();
				
				// if car not visible destroy
				var carRect:Rectangle = new Rectangle(car.x - car.width/2, car.y - car.height/2, car.width, car.height);
				trace(stageRect + ", " + carRect);
				if (!stageRect.containsRect(carRect))
				{
					car.Destroy();
					cars.splice(i);
				}
				i++;
			}
		}
	}

}