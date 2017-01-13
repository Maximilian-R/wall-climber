package {
	import states.IState;

	public class ChancheStateEvent extends Event {
		
		private var _state:IState;
		
		public function ChancheStateEvent(type:String, bubbles:Boolean=false, data:Object=null) {
			super(type, bubbles, data);
			
		}
	}
}