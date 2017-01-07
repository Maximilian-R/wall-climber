package core {
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite {
		private var currentState:Play = null;
		
		public function Game() {
			if (stage) { 
				init(); }
			else { 
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			currentState = new Play();
			addChild(Sprite(currentState));
			currentState.init();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			currentState.update();
		}
	}
}