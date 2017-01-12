package GUI {
	import core.Config;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class GameInfo extends Sprite {
		
		private var _strengthLabel:TextField;
		private var _pauseLabel:TextField;
		private var _startLabel:TextField;
		//private var _pausedLabel
		
		public function GameInfo() {
			touchable = false;
			
			var format:TextFormat = new TextFormat("PermanentMarker", 36, 0xF73346, Align.LEFT, Align.BOTTOM);
			_strengthLabel = new TextField(Config.WORLD_WIDTH, 60, "STRENGTH: 100", format);
			_strengthLabel.y = Config.WORLD_HEIGHT - _strengthLabel.height;
			addChild(_strengthLabel);
			
			format= new TextFormat("PermanentMarker", 46, 0xFFFFFF, Align.CENTER, Align.CENTER);
			_startLabel = new TextField(Config.WORLD_WIDTH, 100, "ATTACH A HAND TO BEGIN", format);
			_startLabel.y = Config.WORLD_HEIGHT * 0.3;
			addChild(_startLabel);
			
			format= new TextFormat("PermanentMarker", 46, 0xFFFFFF, Align.CENTER, Align.CENTER);
			_pauseLabel = new TextField(Config.WORLD_WIDTH, 100, "PAUSED.", format);
			_pauseLabel.y = Config.WORLD_HEIGHT * 0.2;
			addChild(_pauseLabel);
			_pauseLabel.visible = false;
		}
		
		public function setBar(percentage:Number):void {
			_strengthLabel.text = "STRENGTH: " + percentage;
		}
		
		public function pausedLabel(hide:Boolean):void {
			hideLabel(_pauseLabel, hide);
		}
		
		public function startLabel(hide:Boolean):void {
			hideLabel(_startLabel, hide);
		}
		
		public function hideLabel(textfield:TextField, hide:Boolean):void {
			if (hide) {
				textfield.visible = false;
			} else {
				textfield.visible = true;
			}
		}
	}
}