package core {
	
	public class Utils {
		
		public function Utils() {}
		
		public static function randomNum(min:Number, max:Number):Number {
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}
		
		public static function coinFlip():Boolean {
			return (Math.random() > 0.5);
		}
	}
}