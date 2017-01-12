package core {
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Key {
		
		public static var DISPATCHER:EventDispatcher = new EventDispatcher();
		
		private static var _initialized:Boolean = false;
		private static var _keys:Object = {};
		
		public function Key() {}
		
		public static function init(stage:Stage):void {
			if (!_initialized) {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_initialized = true;
			}
		}
		
		public static function isDown(keyCode:uint):Boolean {
			return (keyCode in _keys);
		}
				
		private static function onKeyDown(e:KeyboardEvent):void {
			DISPATCHER.dispatchEvent(new Event("" + e.keyCode));
			_keys[e.keyCode] = true;
		}
		
		private static function onKeyUp(e:KeyboardEvent):void {
			delete _keys[e.keyCode];
		}
	}
}	