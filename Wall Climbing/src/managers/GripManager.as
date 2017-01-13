package managers {
	import core.Assets;
	import core.Config;
	import core.Utils;
	import flash.geom.Point;
	import gameobjects.Grip;
	import starling.display.Image;
	import starling.display.Sprite;
	import states.PlayState;

	public class GripManager extends Sprite {
		
		private var _gripsPerWall:Number = 0;
		private var _world:PlayState = null;
		private var _wallWitdh:Number;
		private var _wallHeight:Number;
		private var _wallMargin:Number = 200;
		private var _wallHeightMultiplier:Number = 0;
		private var _gridScale:Number = 10;
		private var _wall1:Sprite;
		private var _wall2:Sprite;
		private var _onCurrentWall:Sprite;
		
		public function GripManager(world:PlayState) {
			_world = world;
			
			loadSettings();
			
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
		
		private function loadSettings():void {
			_gripsPerWall = Config.getNumber("wall", "grips");
			_gridScale = Config.getNumber("wall", "gridSize");
			_wallWitdh = _world.stage.stageWidth;
			_wallHeight = _world.stage.stageHeight;
		}
		
		private function populateWall(wall:Sprite):void {
			
			if (wall.getChildAt(0) is Image) {
				var rock:Image = wall.getChildAt(0) as Image;
				rock.y = - (_wallHeight * _wallHeightMultiplier);
			}
			
			var grips:Vector.<Point> = getGripPositions();
			for each (var point:Point in grips)  {
				var grip:Grip = new Grip(point.x, point.y, _world._physicsWorld);
				wall.addChild(grip);
			}
		}
		
		private function rePositionWall(wall:Sprite):void {
				
			if (wall.getChildAt(0) is Image) {
				var rock:Image = wall.getChildAt(0) as Image;
				rock.y = - (_wallHeight * _wallHeightMultiplier);
			}
				
			var grips:Vector.<Point> = getGripPositions();
			//index 0 is background sprite
			for (var i:int = 1; i < wall.numChildren; i++) {
				var grip:Grip = wall.getChildAt(i) as Grip;
				grip.updatePosition(grips[i-1].x, grips[i-1].y);
			}
			
			if (_onCurrentWall == _wall1){
				_onCurrentWall = _wall2;
			} else {
				_onCurrentWall = _wall1;
			}
		}
		
		
		private function getGripPositions():Vector.<Point> {
			var gridsUsed:Vector.<Point> = new Vector.<Point>;
			//Add one for first comparison in while loop.
			gridsUsed.push(new Point());
			
			var x:Number;
			var y:Number;
			
			for (var i:int = 0; i < _gripsPerWall; i++) {
				var point:Point;
				
				while (true) {
					var isUnique:Boolean = true;
					x = Utils.randomNum(0, _gridScale);
					//-1 to avoid positions on edges of wall. 
					y = Utils.randomNum(1, _gridScale - 1);
					point = new Point(x, y);
						
					for each (var pointTemp:Point in gridsUsed) {
						//trace(point + " ?= " + pointTemp)
						if (point.equals(pointTemp)) {
							isUnique = false;
						}
					}
					
					if (isUnique) {
						gridsUsed.push(point);
						break;
					}
				}
			}
			gridsUsed.removeAt(0);
			
			var grips:Vector.<Point> = new Vector.<Point>;
			for each (pointTemp in gridsUsed) {
				pointTemp.x = _wallMargin + (pointTemp.x * ((_wallWitdh - (_wallMargin * 2)) / _gridScale));
				pointTemp.y = (pointTemp.y * (_wallHeight / _gridScale)) - point.y - (_wallHeight * _wallHeightMultiplier);
				grips.push(pointTemp);
			}
			
			_wallHeightMultiplier++;
			
			return grips;
		}
		
		public function update(cameraY:Number):void {
			if (cameraY >= _wallHeight * (_wallHeightMultiplier - 1)) {
				rePositionWall(_onCurrentWall);
			}
		}
	}
}