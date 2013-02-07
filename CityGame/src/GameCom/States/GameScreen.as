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
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.MissionManager;
	import GameCom.Managers.NPCManager;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.GameComponents.Water;
	import GameCom.Managers.PlacesManager;
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
		// Constants
		public static const SCROLL_DISTANCE:Number = 10; //pixels per frame
		
		// World stuff
		public var world:b2World;
		
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
		
		private var debugDrawLayer:Sprite = new Sprite();
		
		private var npcManager:NPCManager;
		private var bgManager:BGManager;
		private var scenicManager:ScenicManager;
		private var placesManager:PlacesManager;
		
		private var gui:GUIManager;
		
		private var player:PlayerTruck;
		
		private var previousFrameTime:Number = 0;
		
		//olol toggle bool for mute
		private var mDown:Boolean = false;
		
		public function GameScreen() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:* = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			//Load up the helpers
			MoneyHelper.Initialize();
			ReputationHelper.Initialize();
			ResourceHelper.Initialize();
			MissionManager.Initialize();
			
			//Start the system
			world = new b2World(new b2Vec2(0, 0), true);
			
			// set debug draw
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(debugDrawLayer);
			dbgDraw.SetDrawScale(Global.PHYSICS_SCALE);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			world.SetDebugDraw(dbgDraw);
			
			this.addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(Event.RESIZE, Redraw, false, 0, true);
			Redraw();
			
			previousFrameTime = getTimer();
			
			this.addChild(worldSpr);
			
			worldSpr.addChild(waterLayer);
			worldSpr.addChild(groundLayer);
			worldSpr.addChild(object0Layer);
			worldSpr.addChild(placesLayer);
			worldSpr.addChild(object1Layer);
			
			worldSpr.addChild(debugDrawLayer);
			
			StaticBoxCreator.CreateBoxes(world);
			
			// player is added to objectLayer
			player = new PlayerTruck(new b2Vec2(11000/Global.PHYSICS_SCALE, 15450/Global.PHYSICS_SCALE), world, placesLayer);
			
			// bgManager (ground) is added to groundLayer
			bgManager = new BGManager(groundLayer, player);
			
			// objManager is added to objectLayer
			npcManager = new NPCManager(player, world, object0Layer);
			
			// scenic managers for the 2 object layers
			scenicManager = new ScenicManager(object0Layer, object1Layer, player, world);
			
			// places manager gets its layer
			placesManager = new PlacesManager(placesLayer, player, world);
			
			world.SetContactListener(new CollisionSolver(player, npcManager));
			
			WorldPhysicsLoader.InjectPhysicsIntoWorld(world);
			
			gui = new GUIManager(player, Pause);
			this.addChild(gui);
			
			//player.Respawn();
			
			simulating = true;
			Update(null);
			
			MissionManager.GenerateAllMissions();
		}
		
		private function Update(e:Event):void {
			if (simulating) {
				world.Step(Global.TIME_STEP, Global.VELOCITY_ITERATIONS, Global.POSITION_ITERATIONS);
				world.ClearForces();
				
				//Update the objects
				player.Update(Global.TIME_STEP);
				npcManager.Update();
				
				worldSpr.x = Math.floor(-player.x + stage.stageWidth/2);
				worldSpr.y = Math.floor( -player.y + stage.stageHeight / 2);
				
				if (Keys.isKeyDown(Keyboard.M)) {
					GUIManager.I.ActivateMap();
				}
			}
			
			//Update the things that draw
			waterLayer.Update();
			bgManager.Update();
			scenicManager.DrawScenicObjects();
			placesManager.DrawObjects();
			
			gui.Update();
			
			if(Keys.isKeyDown(Keyboard.P)) {
				world.DrawDebugData();
			} else {
				debugDrawLayer.graphics.clear();
			}
			
			if (mDown && !Keys.isKeyDown(Keyboard.Q)) {
				AudioController.SetMuted(!AudioController.GetMuted());
			}
			mDown = Keys.isKeyDown(Keyboard.Q);
		}
		
		public function Redraw(e:*= null):void {
			//What even is this supposed to do?
		}
		
		private function Pause():void {
			simulating = !simulating;
		}
	}
}