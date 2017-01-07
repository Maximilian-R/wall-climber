package core {
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;

	public class Grip extends Sprite {
		
		private var _width:Number = 10;
		private var _height:Number = 10;
		
		public function Grip(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			setupBody();
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
			box.SetAsBox( _width / Config.WORLD_SCALE, _height / Config.WORLD_SCALE);
			bodyDef.position.Set(startX, startY);
			
			
			fixtureDef.shape = box;
			/* Disable Collision */ 
			var filter:b2FilterData = new b2FilterData()
			filter.categoryBits = 0x0000;
			fixtureDef.filter = filter;
			
			var grip:b2Body = Play.world.CreateBody(bodyDef);
			grip.CreateFixture(fixtureDef);
		}
	}
}