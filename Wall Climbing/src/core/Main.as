package core {
	
	import flash.events.Event;
	import starling.core.Starling;
	import flash.display.Sprite;

	public class Main extends Sprite {
		
		public function Main() {
			Config.loadConfig();
			Config.DISPATCHER.addEventListener(Event.COMPLETE, init, false, 0, true);
		}
		
		private function init(e:Event):void {
			var star:Starling = new Starling(GameStateMachine,stage);
			star.showStats = false;
			star.start();
		}
	}
}