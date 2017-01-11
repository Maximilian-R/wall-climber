package gameobjects {
	import starling.display.Sprite;

	public class BodyPartData {
		
		private var _sprite:Sprite;
		private var _isGrabable:Boolean;
		
		public function BodyPartData(sprite:Sprite, isGrabable:Boolean = false) {
			_sprite = sprite;
			_isGrabable = isGrabable;
		}
		
		public function get isGrabable():Boolean {
			return _isGrabable;
		}
		
		public function set isGrabable(value:Boolean):void {
			_isGrabable = value;
		}
		
		public function get sprite():Sprite {
			return _sprite;
		}
	}
}