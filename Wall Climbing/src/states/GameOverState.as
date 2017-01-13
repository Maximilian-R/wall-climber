package states {
	import core.Config;
	import core.Key;
	import core.WallOfFame;
	import core.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	
	import flash.ui.Keyboard;
	
	
	public class GameOverState extends Sprite implements IState {	
		private var _gameOverLabel:TextField;
		private var _scoreLabel:TextField;
		private var _highScoreLabel:TextField;
		private var _playAgainLabel:TextField;
		private var _background:Image;
		private var _score:Number = 0;
		
		private var _returnState:IState = null;
		
		public function GameOverState(score:Number) {
			_score = score;
			
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
			
			WallOfFame.addScore(_score);
			
			var textFormat:TextFormat = new TextFormat("PermanentMarker", Config.getNumber("theme", "headLineSize"), Config.getColor("theme", "primaryColor"));
			_gameOverLabel = new TextField(stage.stageWidth, 200, "GAME OVER", textFormat);
			addChild(_gameOverLabel);
			
			textFormat = new TextFormat("PermanentMarker", Config.getNumber("theme", "btnSize"), Config.getColor("theme", "secondaryColor"));
			_scoreLabel = new TextField(stage.stageWidth, 100, "YOUR SCORE: " + _score + "M", textFormat);
			addChild(_scoreLabel);
			
			_highScoreLabel = new TextField(stage.stageWidth, 100, "HIGHSCORE: " + WallOfFame.getHighScore() + "M", textFormat);
			addChild(_highScoreLabel);
			
			_scoreLabel.y = _gameOverLabel.height;
			_highScoreLabel.y = _scoreLabel.y + _scoreLabel.height;
			
			textFormat = new TextFormat("PermanentMarker", Config.getNumber("theme", "btnSize"), Config.getColor("theme", "extraColor"));
			_playAgainLabel = new TextField(stage.stageWidth, 100, "ENTER TO PLAY AGAIN", textFormat);
			addChild(_playAgainLabel);
			_playAgainLabel.y = stage.stageHeight - _playAgainLabel.height;
			
			Key.DISPATCHER.addEventListener(Keyboard.ENTER + "", backToMainMenu);
		}
		
		public function update():IState {
			return _returnState;
		}
		
		public function destroy():void {
			Key.DISPATCHER.removeEventListener(Keyboard.ESCAPE + "", backToMainMenu);
		
			_gameOverLabel.removeFromParent(true);
			_gameOverLabel = null;
			_scoreLabel.removeFromParent(true);
			_scoreLabel = null;
			_highScoreLabel.removeFromParent(true);
			_highScoreLabel = null;
			_playAgainLabel.removeFromParent(true);
			_playAgainLabel = null;
		}
		
		private function backToMainMenu(e:Event):void {
			_returnState = new PlayState();
		}
	}
}