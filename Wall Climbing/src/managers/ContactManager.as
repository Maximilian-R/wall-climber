package managers {
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactFilter;
	import Box2D.Dynamics.b2ContactListener;

	public class ContactManager extends b2ContactListener {
		
		public function ContactManager() {
		}
		
		override public function BeginContact(contact:b2Contact):void {
		}
		
		override public function EndContact(contact:b2Contact):void {
			
		}
	}
}