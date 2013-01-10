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
	import GameCom.GameComponents.ObjManager;
	import GameCom.GameComponents.PlayerTruck;
	import GameCom.GameComponents.Water;
	import LORgames.Engine.Keys;
	import GameCom.Helpers.StaticBoxCreator;
	import GameCom.GameComponents.BGManager;
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
		private var renderWorld:Boolean = true;
		
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
		private var objectLayer:Sprite = new Sprite();
		private var roofLayer:Sprite = new Sprite();
		
		private var objManager:ObjManager;
		private var bgManager:BGManager;
		private var roofManager:BGManager;
		
		// The scrolling/scalling container
		private var myContainer:Sprite = new Sprite();
		
		private var player:PlayerTruck;
		
		public function GameScreen() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:* = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			//Start the system
			world = new b2World(new b2Vec2(0, 0), true);
			
			// set debug draw
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(objectLayer);
			dbgDraw.SetDrawScale(Global.PHYSICS_SCALE);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_centerOfMassBit);
			world.SetDebugDraw(dbgDraw);
			
			this.addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(Event.RESIZE, Redraw, false, 0, true);
			Redraw();
			
			this.addChild(worldSpr);
			
			worldSpr.addChild(waterLayer);
			worldSpr.addChild(groundLayer);
			worldSpr.addChild(objectLayer);
			worldSpr.addChild(roofLayer);
			
			StaticBoxCreator.CreateBoxes(world);
			
			//TODO: bgManager (ground) is added to groundLayer
			bgManager = new BGManager(groundLayer);
			
			// player is added to objectLayer
			player = new PlayerTruck(new b2Vec2(10, 10), world, objectLayer);
			
			// objManager is added to objectLayer
			objManager = new ObjManager(player, world, worldSpr);
			
			//TODO: objManager should handle roof
		}
		
		private function Update(e:Event):void {
			if (simulating) {
				//Update the objects
				waterLayer.Update();
				bgManager.Update();
				player.Update();
				objManager.Update();
				
				world.Step(Global.TIME_STEP, Global.VELOCITY_ITERATIONS, Global.POSITION_ITERATIONS);
				world.ClearForces();
				
				worldSpr.x = -player.x + stage.stageWidth/2;
				worldSpr.y = -player.y + stage.stageHeight / 2;
				
				groundLayer.x = worldSpr.x;
				groundLayer.y = worldSpr.y;
				
				//TODO: Make objects register for updates rather than checking EVERY object for updates...
				
				//TODO: Decide if this legacy code is actually needed in this game
				/*var b2:b2Body = world.GetBodyList();
				
				while(b2 != null) {
					
					if (b2.GetUserData() is UpdateComponent) {
						(b2.GetUserData() as UpdateComponent).Update();
					}
					
					b2 = b2.GetNext();
				}*/
			}
			
			//TODO: These should be given to the truck to control :)
			if (Keys.isKeyDown(Keyboard.LEFT)) {
				myContainer.x += SCROLL_DISTANCE;
				Redraw();
			}
			
			if (Keys.isKeyDown(Keyboard.RIGHT)) {
				myContainer.x -= SCROLL_DISTANCE;
				Redraw();
			} 
			
			if (Keys.isKeyDown(Keyboard.UP)) {
				myContainer.y += SCROLL_DISTANCE;
				Redraw();
			}
			
			if (Keys.isKeyDown(Keyboard.DOWN)) {
				myContainer.y -= SCROLL_DISTANCE;
				Redraw();
			}
			
			if(renderWorld) {
				//world.DrawDebugData();
			}
		}
		
		public function Redraw(e:*= null):void {
			//What even is this supposed to do?
		}
	}
}