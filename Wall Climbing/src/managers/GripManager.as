package managers {
	import core.Assets;
	import core.Config;
	import core.Level;
	import core.Utils;
	import gameobjects.Grip;
	import starling.display.Image;
	import starling.display.Sprite;

	public class GripManager extends Sprite {
		
		private var _currentLevel:Level = null;
		private var _world:Sprite = null;
		private var _wallWitdh:Number;
		private var _wallHeight:Number;
		private var _wallMargin:Number = 200;
		private var _wallHeightMultiplier:Number = 0;
		private var _gridScale:Number = 10;
		private var _wall1:Sprite;
		private var _wall2:Sprite;
		private var _onCurrentWall:Sprite;
		
		public function GripManager(world:Sprite) {
			_world = world;
			
			loadSettings(Config.getLevel(1));
			
			_wall1 = setupWall();
			_wall2 = setupWall();
			
			populateWall(_wall1);
			populateWall(_wall2);
			
			_onCurrentWall = _wall1;
		}
		
		private function setupWall():Sprite {
			var wall:Sprite = new Sprite();
			wall.height = _world.height;
			wall.width = _wallWitdh;
			
			addBackground(wall);
			addChild(wall);
			
			return wall;
		}
		
		private function addBackground(wall:Sprite):void {
			var rock:Image = new Image(Assets.ROCK_TEXTURE);
			rock.width = _wallWitdh;
			rock.height = _wallHeight;
			wall.addChild(rock);
		}
		
		private function loadSettings(level:Level):void {
			_currentLevel = level;
			
			_wallWitdh = _world.stage.stageWidth;
			_wallHeight = _world.stage.stageHeight;
		}
		
		private function populateWall(wall:Sprite):void {
			
			if (wall.getChildAt(0) is Image) {
				var rock:Image = wall.getChildAt(i) as Image;
				rock.y = - (_wallHeight * _wallHeightMultiplier);
			}
			
			
			
			
			for (var i:int = 0; i < _currentLevel.grips; i++) {
				var x:Number = Utils.randomNum(0, _gridScale);
				var y:Number = Utils.randomNum(0, _gridScale);
				x = _wallMargin + (x * ((_wallWitdh - (_wallMargin * 2)) / _gridScale));
				y = y * (_wallHeight / _gridScale);
				var grip:Grip = new Grip(x, y - (_wallHeight * _wallHeightMultiplier));
				wall.addChild(grip);
			}
			
			_wallHeightMultiplier++;
		}
		
		private function rePositionWall(wall:Sprite):void {
			
			for (var i:int = 0; i < _currentLevel.grips; i++) {
				
				if (wall.getChildAt(i) is Image) {
					var rock:Image = wall.getChildAt(i) as Image;
					rock.y = - (_wallHeight * _wallHeightMultiplier);
					continue;
				}
				
				var x:Number = Utils.randomNum(0, _gridScale);
				x = _wallMargin + (x * ((_wallWitdh - (_wallMargin * 2)) / _gridScale));
				var y:Number = Utils.randomNum(0, _gridScale);
				y = y * (_wallHeight / _gridScale);
				
				var grip:Grip = wall.getChildAt(i) as Grip;
				grip.updatePosition(x, y - (_wallHeight * _wallHeightMultiplier));
			}
			
			_wallHeightMultiplier++;
			
			if (_onCurrentWall == _wall1){
				_onCurrentWall = _wall2;
			} else {
				_onCurrentWall = _wall1;
			}
		}
		
		public function update(cameraY:Number):void {
			if (cameraY >= _wallHeight * (_wallHeightMultiplier - 1)) {
				rePositionWall(_onCurrentWall);
				trace(cameraY)
			}
		}
	}
}