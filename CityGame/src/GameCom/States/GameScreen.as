package GameCom.States {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import GameCom.GameComponents.CollisionSolver;
	import GameCom.Helpers.MoneyHelper;
	import GameCom.Helpers.ReputationHelper;
	import GameCom.Helpers.ResourceHelper;
	import GameCom.Helpers.WorldPhysicsLoader;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.MissionManager;
	import GameCom.Managers.NPCManager;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.GameComponents.Water;
	import GameCom.Managers.PlacesManager;
	import GameCom.Managers.WorldManager;
	import GameCom.SystemMain;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import GameCom.Helpers.StaticBoxCreator;
	import GameCom.Managers.BGManager;
	import GameCom.Managers.ScenicManager;
	import LORgames.Engine.Logger;
	import LORgames.Engine.MessageBox;
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class GameScreen extends Sprite {
		// Playing the world
		private var simulating:Boolean = true;
		
		// Sprites to draw in to
		// worldSpr contains the 3 layers
		// groundLayer contains images drawn on the ground layer
		// objectLayer contains images drawn on the ground layer
		// roofLayer contains images drawn on the ground layer
		private var worldSpr:Sprite = new Sprite();
		
		private var waterLayer:Water = new Water();
		private var groundLayer:Sprite = new Sprite();
		private var object0Layer:Sprite = new Sprite();
		private var placesLayer:Sprite = new Sprite();
		private var object1Layer:Sprite = new Sprite();
		
		private var npcManager:NPCManager;
		private var bgManager:BGManager;
		private var scenicManager:ScenicManager;
		private var placesManager:PlacesManager;
		
		private var explosionManager:ExplosionManager;
		
		private var gui:GUIManager;
		
		private var player:PlayerTruck;
		
		//olol toggle bool for mute
		private var mDown:Boolean = false;
		
		public static var EndOfTheLine_TerminateASAP:Boolean = false;
		
		public function GameScreen() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:* = null):void {
			EndOfTheLine_TerminateASAP = false;
			
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			stage.focus = stage;
			
			//Clear out all the dead bodies
			WorldManager.CleanupDynamics();
			
			//Load up the helpers
			MoneyHelper.Initialize();
			ReputationHelper.Initialize();
			ResourceHelper.ResetResources();
			MissionManager.ResetMissions();
			
			this.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			this.addChild(worldSpr);
			
			worldSpr.addChild(waterLayer);
			worldSpr.addChild(groundLayer);
			worldSpr.addChild(object0Layer);
			worldSpr.addChild(placesLayer);
			worldSpr.addChild(object1Layer);
			
			worldSpr.addChild(WorldManager.debugDrawLayer);
			
			// player is added to objectLayer
			player = new PlayerTruck(new b2Vec2(11050/Global.PHYSICS_SCALE, 15640/Global.PHYSICS_SCALE), placesLayer, object1Layer);
			
			// bgManager (ground) is added to groundLayer
			bgManager = new BGManager(groundLayer, player);
			
			// objManager is added to objectLayer
			npcManager = new NPCManager(player, object0Layer);
			
			// scenic managers for the 2 object layers
			scenicManager = new ScenicManager(object0Layer, object1Layer, player);
			
			// places manager gets its layer
			placesManager = new PlacesManager(placesLayer, player);
			
			WorldManager.World.SetContactListener(new CollisionSolver(player, npcManager));
			
			gui = new GUIManager(player, Pause, MockUpdate);
			this.addChild(gui);
			
			explosionManager = new ExplosionManager(placesLayer, object1Layer);
			
			//player.Respawn();
			
			simulating = true;
			MockUpdate();
			
			MissionManager.GenerateAllMissions();
		}
		
		private function Update(e:Event):void {
			if (simulating) {
				WorldManager.World.Step(Global.TIME_STEP, Global.VELOCITY_ITERATIONS, Global.POSITION_ITERATIONS);
				WorldManager.World.ClearForces();
				
				//Update the objects
				player.Update(Global.TIME_STEP);
				npcManager.Update();
				
				explosionManager.Update();
				
				if(stage) {
					worldSpr.x = Math.floor(-player.x + stage.stageWidth/2);
					worldSpr.y = Math.floor( -player.y + stage.stageHeight / 2);
					
					if (Keys.isKeyDown(Keyboard.M)) {
						GUIManager.I.ActivateMap();
					}
				}
			}
			
			//Update the things that draw
			waterLayer.Update();
			bgManager.Update();
			scenicManager.DrawScenicObjects();
			placesManager.DrawObjects();
			
			gui.Update();
			
			if(Keys.isKeyDown(Keyboard.B) && Keys.isKeyDown(Keyboard.U) && Keys.isKeyDown(Keyboard.G)) {
				WorldManager.World.DrawDebugData();
			} else {
				WorldManager.debugDrawLayer.graphics.clear();
			}
			
			if (mDown && !Keys.isKeyDown(Keyboard.Q)) {
				AudioController.SetMuted(!AudioController.GetMuted());
			}
			mDown = Keys.isKeyDown(Keyboard.Q);
			
			if (EndOfTheLine_TerminateASAP) {
				Cleanup();
				SystemMain.instance.StateTo(new EndGame());
			}
		}
		
		public function MockUpdate():void {
			WorldManager.World.Step(0, Global.VELOCITY_ITERATIONS, Global.POSITION_ITERATIONS);
			WorldManager.World.ClearForces();
			
			//Update the objects
			player.Update(0);
			
			worldSpr.x = Math.floor(-player.x + stage.stageWidth/2);
			worldSpr.y = Math.floor( -player.y + stage.stageHeight / 2);
		}
		
		private function Pause():void {
			simulating = !simulating;
		}
		
		private function Cleanup():void {
			worldSpr = null;
			
			waterLayer = null;
			groundLayer = null;
			object0Layer = null;
			placesLayer = null;
			object1Layer = null;
			
			npcManager = null;
			bgManager = null;
			scenicManager = null;
			placesManager = null;
			
			gui = null;
			
			player = null;
			
			simulating = false;
			
			this.removeEventListener(Event.ENTER_FRAME, Update);
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
	}
}