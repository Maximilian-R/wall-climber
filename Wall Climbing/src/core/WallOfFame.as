package core {
	import flash.net.SharedObject;
	
	public class WallOfFame {
		
		private static var _shared:SharedObject = SharedObject.getLocal("highScoreList");
		private static var _highScore:Array = new Array();
		
		public function WallOfFame() {
			load();
		}
		
		public static function load():void {
			if (_shared.data.scores) {
				_highScore = _shared.data.scores;
			} else {
				trace("No data found in sharedObject");
				var newRow:Array = new Array("Unkown", 0);
				_highScore.push(newRow);
			}
		}
		
		public static function addScore(score:Number):void {
			var newRow:Array = new Array("Name...", score);
			var oldRow:Array = _highScore[0];
			
			if (newRow[1] > oldRow[1]) {
				_highScore.removeAt(0);
				_highScore.push(newRow);
			}
			save();
		}
		
		private static function save():void {
			_shared.data.scores = _highScore;
			_shared.flush();
			_shared.close();
		}
		
		public static function getHighScore():Number {
			var row:Array = _highScore[0];
			return row[1];
		}
	}
}