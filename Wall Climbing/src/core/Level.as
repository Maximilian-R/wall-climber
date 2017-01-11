package core {
	
	public class Level {
		private var _level:Number;
		private var _height:Number;
		private var _width:Number;
		private var _grips:Number;
		
		public function Level(level:Number, height:Number, width:Number, grips:Number) {
			_level = level;
			_height = height;
			_width = width;
			_grips = grips;
		}	
		
		/* ------------------ GETTERS ----------------------*/ 
		public function get level():Number { return _level; }
		public function get height():Number { return _height; }
		public function get width():Number { return _width; }
		public function get grips():Number { return _grips; }
		
		/* ------------------ SETTERS ----------------------*/
		public function set level(value:Number):void { _level = value; }
		public function set height(value:Number):void { _height = value; }
		public function set width(value:Number):void { _width = value; }
		public function set grips(value:Number):void { _grips = value; }
	}
}