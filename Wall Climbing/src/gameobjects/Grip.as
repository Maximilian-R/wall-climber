package gameobjects {
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import core.Assets;
	import core.Config;
	import core.Utils;
	import states.PlayState;
	import flash.display.Bitmap;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class Grip extends Sprite {
		
		private var _width:Number = 30;
		private var _height:Number = 30;
		private var _image:Image;
		private var _body:b2Body;
		private var _physicsWorld:b2World;
		
		public function Grip(x:Number, y:Number, physicsWorld:b2World) {
			_physicsWorld = physicsWorld;
			
			this.x = x;
			this.y = y;
			setupBody();
			
			_image = new Image(Assets.gripTextures[Utils.randomNum(0, 7)]);
			_image.alignPivot();
			_image.width = _width;
			_image.height = _height;
			
			addChild(_image);
		}
		
		private function setupBody():void {
			var bodyDef:b2BodyDef = new b2BodyDef();
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			var box:b2PolygonShape;
			
			// Define initial position of charachter build
			var startX:Number = this.x / Config.WORLD_SCALE;
			var startY:Number = this.y / Config.WORLD_SCALE;
			
			bodyDef.type = b2Body.b2_staticBody;
			box = new b2PolygonShape();
			
			//SetAsBox, half width/height as argument
			box.SetAsBox( _width * 0.5 / Config.WORLD_SCALE, _height * 0.5 / Config.WORLD_SCALE);
			bodyDef.position.Set(startX, startY);
			
			fixtureDef.shape = box;
			fixtureDef.isSensor = true;
			
			var grip:b2Body = _physicsWorld.CreateBody(bodyDef);
			_body = grip;
			grip.CreateFixture(fixtureDef);
			grip.SetUserData(this);
		}
		
		public function updatePosition(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
			_body.SetPosition(new b2Vec2(x / Config.WORLD_SCALE, y / Config.WORLD_SCALE));
		}
	}
}