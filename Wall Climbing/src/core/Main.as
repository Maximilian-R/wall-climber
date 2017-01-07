package core {
	
	import starling.core.Starling;
	import flash.display.Sprite;

	public class Main extends Sprite {
		
		public function Main() {
			var star:Starling = new Starling(Game,stage);
			star.showStats = true;
			star.start();
		}
	}
}