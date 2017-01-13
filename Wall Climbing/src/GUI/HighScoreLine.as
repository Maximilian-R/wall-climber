package GUI {
	import core.Config;
	import core.WallOfFame;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	public class HighScoreLine extends Sprite {
		
		public function HighScoreLine(width:Number) {
			var redLine:Texture = Texture.fromColor(width, 10, 0xFF0000, 0.5);
			var image:Image = new Image(redLine);
			addChild(image);
			
			var format:TextFormat = new TextFormat("PermanentMarker",  Config.getNumber("theme", "textSize"), Config.getColor("theme", "secondaryColor"), Align.LEFT);
			var label:TextField = new TextField(width, 100, "HIGHSCORE", format);
			addChild(label);
			
			label.y = image.y - label.height * 0.5;
			
		}
	}
}