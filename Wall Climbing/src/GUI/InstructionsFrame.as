package GUI {
	import core.Assets;
	import core.Config;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;

	public class InstructionsFrame extends Sprite {
		
		private static const HAND_SIZE:Number = 70;
		private static const HAND_ROTATION:Number = 20;
		
		
		public function InstructionsFrame() {
			
			var textFormat:TextFormat = new TextFormat("PermanentMarker", 38, 0x00B1BB);
			var _label:TextField = new TextField(Config.WORLD_WIDTH, 100, "DRAG AND DROP HANDS AND FEETS", textFormat);
			_label.alignPivot();
			_label.y = -_label.height;
			addChild(_label);
			
			var leftHand:Image = new Image(Assets.HAND_TEXTURE);
			leftHand.alignPivot();
			leftHand.width = HAND_SIZE;
			leftHand.height = HAND_SIZE;
			leftHand.x = -leftHand.width;
			leftHand.rotation = -HAND_ROTATION;
			
			var rightHand:Image = new Image(Assets.HAND_TEXTURE);
			rightHand.alignPivot();
			rightHand.width = HAND_SIZE;
			rightHand.height = HAND_SIZE;
			rightHand.x = rightHand.width;
			rightHand.rotation = HAND_ROTATION;
			rightHand.scaleX *= -1;
			
			addChild(leftHand);
			addChild(rightHand);
		}
	}
}