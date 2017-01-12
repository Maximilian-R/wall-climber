package core {
	
	import states.IState;
	import states.MenuState;
	import states.PlayState;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite {
		private var _currentState:IState;
		
		public function Game() {
			if (stage) { 
				init(); }
			else { 
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Assets.init();
			WallOfFame.load();
			Key.init(stage);
			
			_currentState = new MenuState();
			addChild(Sprite(_currentState));
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function onEnterFrame(e:Event):void {
			var newState:IState = _currentState.update();
			if (newState != null) {
				setState(newState);
			}
		}
		
		private function setState(state:IState):void {
			if (_currentState != null) {
				_currentState.destroy();
				removeChild(_currentState as DisplayObject);
			}
			_currentState = state;
			addChild(state as DisplayObject);
		}
	}
}