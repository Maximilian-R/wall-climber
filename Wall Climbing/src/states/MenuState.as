package states {
	import GUI.InstructionsFrame;
	import SFX.SoundManager;
	import core.Config;
	import core.Assets;
	import starling.display.Button;
	import starling.textures.Texture;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	
	import flash.ui.Keyboard;
	
	public class MenuState extends Sprite implements IState {	
		private var _MenuLabel:TextField;
		private var _background:Image;
		private var _playBtn:Button;
		
		private var _returnState:IState = null;
		
		public function MenuState() {
			if (stage) { 
				init(); }
			else { 
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var _background:Image = new Image(Assets.ROCK_TEXTURE);
			_background.width = Config.WORLD_WIDTH;
			_background.height = Config.WORLD_HEIGHT;
			addChild(_background);
			
			var textFormat:TextFormat = new TextFormat("PermanentMarker", Config.getNumber("theme", "headLineSize"), Config.getColor("theme", "primaryColor"));
			_MenuLabel = new TextField(stage.stageWidth, 200, "BOULDERING!", textFormat);
			addChild(_MenuLabel);
			
			var texture:Texture = Texture.fromColor(stage.stageWidth, 200, 0x000000, 0.0);
			_playBtn = new Button(texture, "CLICK HERE TO PLAY");
			_playBtn.textFormat = new TextFormat("PermanentMarker", Config.getNumber("theme", "btnSize"), Config.getColor("theme", "secondaryColor"));
			addChild(_playBtn);
			_playBtn.y = stage.stageHeight - _playBtn.height;
			
			_playBtn.addEventListener(Event.TRIGGERED, startGame);
			
			var instructions:InstructionsFrame = new InstructionsFrame();
			instructions.alignPivot();
			instructions.x = stage.stageWidth * 0.5;
			instructions.y = stage.stageHeight * 0.5;
			
			addChild(instructions);
		}
		
		public function update():void {
		}
		
		public function destroy():void {	
			_playBtn.removeEventListener(Event.TRIGGERED, startGame);
			
			_MenuLabel.removeFromParent(true);
			_MenuLabel = null;
			_playBtn.removeFromParent(true);
			_playBtn = null;
		}
		
		private function startGame(e:Event):void {
			dispatchEvent(new Event(Config.CHANGE_STATE_EVENT, false, new PlayState()));
		}
	}
}