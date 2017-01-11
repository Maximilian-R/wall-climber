package physics {
	import Box2D.Dynamics.b2ContactFilter;
	import Box2D.Dynamics.b2Fixture;

	public class ContactFilter extends b2ContactFilter {
		
		public function ContactFilter() {
			
		}
		
		override public function ShouldCollide(fixtureA:b2Fixture, fixtureB:b2Fixture):Boolean {
			return true;
		}
	}
}