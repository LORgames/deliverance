package GameCom.GameComponents {
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import GameCom.Managers.TriggerManager;
	/**
	 * ...
	 * @author ...
	 */
	public class CollisionSolver extends b2ContactListener {
		
		public var truck:PlayerTruck;
		
		public function CollisionSolver(truck:PlayerTruck) {
			this.truck = truck;
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