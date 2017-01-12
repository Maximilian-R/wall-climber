package states {
	
	import GUI.GameInfo;
	import GUI.HighScoreLine;
	import core.Key;
	import core.WallOfFame;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import starling.display.Image;
	import starling.textures.Texture;
	
	import physics.PhysicsWorld;
	import Box2D.Common.Math.b2Vec2;
	
	import core.Config;
	import states.IState;
	import gameobjects.Grip;
	import managers.GripManager;
	import gameobjects.Character;
	
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class PlayState extends Sprite implements IState {
		
		public var _physicsWorld:PhysicsWorld = new PhysicsWorld();
		private var _gripManager:GripManager = null;
		private var _minCameraY:Number = 0;
		
		private var _character:Character = null;
		private var _score:Number = 0;
		private var _highScoreLine:HighScoreLine;
		private var _isPaused:Boolean = false;
		
		private var _gui:GameInfo = new GameInfo();
		
		public function PlayState():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			_gripManager = new GripManager(this);
			addChild(_gripManager)
			
			_character = new Character(_physicsWorld);
			addChild(_character);
			
			if (WallOfFame.getHighScore() > 0) {
				_highScoreLine = new HighScoreLine(stage.stageWidth);
				addChild(_highScoreLine);
				_highScoreLine.y = 300 - WallOfFame.getHighScore() * Config.WORLD_SCALE;
			}
			
			parent.addChild(_gui);
			
			_physicsWorld.addEventListener(Config.GRABBED_GRIP_EVENT, startGame);
			_character.addEventListener(Config.STRENGHT_PERCENTAGE_CHANGED, updateGUI);
			
			Key.DISPATCHER.addEventListener(Keyboard.P + "", pause);
		}
		
		public function pause():void {
			_isPaused = !_isPaused;
			_gui.pausedLabel(!_isPaused);	
		}
		
		public function startGame():void {
			_character.freezeTorso(false);
			_gui.startLabel(true);
		}
		
		private function updateGUI():void {
			_gui.setBar(_character.getPercentageStrentgh());
		}
		
		public function update():IState {
			if (_isPaused) {
				return null;
			}
			
			_character.update();
			
			_gripManager.update(this.y);
			
			_physicsWorld.update();
			camera();
		
			if (outsideWorldBounds()) {
				return new GameOverState(_score);
			}
			return null;
		}
		
		private function updateScore():void {
			_score = int(_minCameraY / Config.WORLD_SCALE);
		}
		
		private function outsideWorldBounds():Boolean {
			if (_minCameraY - getCharYOnCameraSprite() > stage.stageHeight) {
				return true;
			} 
			return false;
		}
		
		private function getCharYOnCameraSprite():Number {
			var yPos:Number = _character.head.GetWorldCenter().y * Config.WORLD_SCALE;
			var charYOnCamSprite:Number = stage.stageHeight / 2 - yPos;
			return charYOnCamSprite;
		}
		
		private function camera():void {
			
			var charYOnCamSprite:Number = getCharYOnCameraSprite();
			if (charYOnCamSprite > _minCameraY) {
				_minCameraY = charYOnCamSprite;
				y = charYOnCamSprite;
				
				//Reposition debug_sprite so debug sprites are aligned with starlings sprites. 
				_physicsWorld.updateDebugSpritePos(charYOnCamSprite);
			}
			
			updateScore();
		}
		
		private function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			
			if (touch) {
				var localWorldPosition:Point = touch.getLocation(this);				
				var b2vec:b2Vec2 = new b2Vec2(localWorldPosition.x /= Config.WORLD_SCALE, localWorldPosition.y /= Config.WORLD_SCALE)
				
				if (touch.phase == TouchPhase.BEGAN) {
					_physicsWorld.mouseDown(b2vec);
				}
				else if (touch.phase == TouchPhase.ENDED) {
					_physicsWorld.mouseRelease();
				}
				else if (touch.phase == TouchPhase.MOVED) {
					_physicsWorld.mouseMove(b2vec);
				}
			}
		}
		
		public function destroy():void {
			stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			_character.removeFromParent(true);
			_gripManager.removeFromParent(true);
			
			parent.removeChild(_gui);
			
			_gui = null;
			_physicsWorld.destroy();
			_physicsWorld = null;
			_minCameraY = 0;
			_character = null;
			_score = 0;
		}
		
		public function get physicsWorld():PhysicsWorld {
			return _physicsWorld;
		}
	}
}