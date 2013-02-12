package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import GameCom.Helpers.StaticBoxCreator;
	import GameCom.Helpers.WorldPhysicsLoader;
	/**
	 * ...
	 * @author Paul
	 */
	public class WorldManager {
		
		public static var World:b2World;
		public static var debugDrawLayer:Sprite = new Sprite();
		
		public static function Initialize():void {
			//Start the system
			World = new b2World(new b2Vec2(0, 0), true);
			
			// set debug draw
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(debugDrawLayer);
			dbgDraw.SetDrawScale(Global.PHYSICS_SCALE);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			World.SetDebugDraw(dbgDraw);
			
			StaticBoxCreator.CreateBoxes(World);
			WorldPhysicsLoader.InjectPhysicsIntoWorld(World);
		}
		
		//Ballsy expensive to call
		public static function CleanupDynamics():void {
			var body:b2Body = World.GetBodyList();
			
			while (body != null) {
				if (body.GetType() == b2Body.b2_dynamicBody) {
					World.DestroyBody(body);
				}
				
				body = body.GetNext();
			}
		}
		
	}

}