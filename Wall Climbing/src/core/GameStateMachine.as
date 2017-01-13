package core {
	
	import states.IState;
	import states.MenuState;
	import states.PlayState;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameStateMachine extends Sprite {
		private var _currentState:IState;
		
		public function GameStateMachine() {
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
			
			
			setState(new MenuState);
			addChild(Sprite(_currentState));
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function onEnterFrame(e:Event):void {
			_currentState.update();
		}
		
		private function setState(state:IState):void {
			var sprite:DisplayObject = _currentState as DisplayObject;
			
			if (_currentState != null) {
				_currentState.destroy();
				sprite.removeEventListener(Config.CHANGE_STATE_EVENT, onChangeState)
				removeChild(sprite);
			}
			
			_currentState = state;
			sprite= _currentState as DisplayObject;
			sprite.addEventListener(Config.CHANGE_STATE_EVENT, onChangeState);
			addChild(state as DisplayObject);
		}
		
		public function onChangeState(e:Event):void {
			setState(e.data as IState);
		}
	}
}