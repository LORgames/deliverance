package GameCom.GameComponents {
	import Box2D.Collision.b2ContactID;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import GameCom.Managers.NPCManager;
	import GameCom.Managers.TriggerManager;
	/**
	 * ...
	 * @author ...
	 */
	public class CollisionSolver extends b2ContactListener {
		
		public var truck:PlayerTruck;
		public var npcManager:NPCManager;
		
		public function CollisionSolver(truck:PlayerTruck, npcManager:NPCManager) {
			this.truck = truck;
			this.npcManager = npcManager;
		}
 
		public override function BeginContact(contact:b2Contact):void {
			var npc:NPCCar;
			if (contact.GetFixtureA().GetUserData() == "collisionScanner") {
				npc = npcManager.GetNPCByName(contact.GetFixtureA().GetBody().GetUserData());
				if (npc != null && (npc.name != contact.GetFixtureB().GetBody().GetUserData())) {
					npc.collisions++;
				}
			}
			if (contact.GetFixtureB().GetUserData() == "collisionScanner") {
				npc = npcManager.GetNPCByName(contact.GetFixtureB().GetBody().GetUserData());
				if (npc != null && (npc.name != contact.GetFixtureA().GetBody().GetUserData())) {
					npc.collisions++;
				}
			}
		}
		
		public override function EndContact(contact:b2Contact):void {
			var npc:NPCCar;
			if (contact.GetFixtureA().GetUserData() == "collisionScanner") {
				npc = npcManager.GetNPCByName(contact.GetFixtureA().GetBody().GetUserData());
				if (npc != null && (npc.name != contact.GetFixtureB().GetBody().GetUserData())) {
					npc.collisions--;
				}
			}
			if (contact.GetFixtureB().GetUserData() == "collisionScanner") {
				npc = npcManager.GetNPCByName(contact.GetFixtureB().GetBody().GetUserData());
				if (npc != null && (npc.name != contact.GetFixtureA().GetBody().GetUserData())) {
					npc.collisions--;
				}
			}
		}
		
        /*public override function BeginContact(contact:b2Contact):void {
			var tFix:b2Body = null;
			var oFix:b2Fixture = null;
			
			if (contact.GetFixtureA().GetBody() == truck.body) {
				tFix = contact.GetFixtureA().GetBody();
				oFix = contact.GetFixtureB();
			}
			
			if (contact.GetFixtureB().GetBody() == truck.body) {
				tFix = contact.GetFixtureB().GetBody();
				oFix = contact.GetFixtureA();
			}
			
			if (tFix != null) {
				if (oFix.GetBody().GetUserData() is PlaceObject && contact.IsTouching()) {
					var place:PlaceObject = oFix.GetBody().GetUserData() as PlaceObject;
					
					if (place.isActive) {
						TriggerManager.ReportTrigger("place_" + place.TriggerValue);
					}
				}
			}
        }*/
		
		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void {
			var tFix:b2Body = null;
			var oFix:b2Fixture = null;
			
			if (contact.GetFixtureA().GetBody() == truck.body) {
				tFix = contact.GetFixtureA().GetBody();
				oFix = contact.GetFixtureB();
			} else if (contact.GetFixtureB().GetBody() == truck.body) {
				tFix = contact.GetFixtureB().GetBody();
				oFix = contact.GetFixtureA();
			}
			
			if (tFix != null) {
				truck.Damage(impulse.normalImpulses[0] + impulse.normalImpulses[1]);
			}
		}
		
	}

}