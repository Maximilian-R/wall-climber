package core {
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.display.Stage;
	import starling.display.Sprite;
	import flash.display.Sprite;
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	//  Box2D is tuned for meters, kilograms, and seconds.

	public class Play extends starling.display.Sprite {
		public static var world:b2World;
		private var _character:Character;
		
		private var _ns:Stage = Starling.current.nativeStage;
		
		public function init():void {
			setupWorld();
			_character = new Character();
			addChild(_character);
			debug_draw();
			
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			//stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			var grip:Grip = new Grip(Config.WORLD_WITDH * 0.5, Config.WORLD_HEIGHT * 0.5);
		}
		
		private function setupWorld():void {
			//Setup World Object			
			var gravity:b2Vec2 = new b2Vec2 (0.0, 10.0);
			var doSleep:Boolean = true;
			
			world = new b2World(gravity, doSleep);
			
			//Create ground body 
			var groundBodyDef:b2BodyDef = new b2BodyDef();
			groundBodyDef.position.Set(0, Config.WORLD_HEIGHT / Config.WORLD_SCALE);
			groundBodyDef.type = b2Body.b2_staticBody;
			
			//Set a shape (fixture) and create it
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(Config.WORLD_WITDH / Config.WORLD_SCALE, (Config.WORLD_HEIGHT * 0.1) / Config.WORLD_SCALE );
			
			//Let world create the body
			var groundBody:b2Body = world.CreateBody(groundBodyDef);
			groundBody.CreateFixture2(shape, 0.0);
		}
		
		private var timeStep:Number = 1.0 / 60.0;
		private var velocityIterations:Number = 10;
		private var positionIterations:Number = 10;

		
		public function update():void {
			//for (var i:Number = 0; i < 60; ++i) {
				world.Step(timeStep, velocityIterations, positionIterations);
				world.ClearForces();
				world.DrawDebugData();
				//var position:b2Vec2 = dynamicBody.GetPosition();
				//var angle:Number = dynamicBody.GetAngle();
				//trace(position.x +',' + position.y +',' + angle);
			//}	
			
			if (mouseJoint) {
				var mouseXWorldPhys:Number = _ns.mouseX/Config.WORLD_SCALE;
				var mouseYWorldPhys:Number = _ns.mouseY/Config.WORLD_SCALE;
				var p2:b2Vec2 = new b2Vec2(mouseXWorldPhys, mouseYWorldPhys);
				mouseJoint.SetTarget(p2);
			}
		}
		
		public function debug_draw():void {
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:flash.display.Sprite = new flash.display.Sprite();
			
			/* ----------------------------------------- Adding degub sprite to native stage does not allow touches ---------------- */ 
			_ns.addChild(debug_sprite);
			debug_draw.SetSprite(debug_sprite);
			debug_draw.SetDrawScale(Config.WORLD_SCALE);
			debug_draw.SetFlags(b2DebugDraw.e_shapeBit);
			debug_draw.AppendFlags(b2DebugDraw.e_jointBit);
			debug_draw.SetFillAlpha(0.3);
			debug_draw.SetLineThickness(2.0);
			
			world.SetDebugDraw(debug_draw);
		}
		
		
		/* http://forum.starling-framework.org/topic/how-listenmouse-eventmouse_down-with-starling */
		public function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(stage);
			if(touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					on_mouse_down();
				}
				else if (touch.phase == TouchPhase.ENDED) {
					on_mouse_up();
				}
				else if(touch.phase == TouchPhase.MOVED) {
				}
			}
		}
		
		/* Starling example, Test.as */ 
		public var mousePVec:b2Vec2 = new b2Vec2();
		public var real_x_mouse:Number;
		public var real_y_mouse:Number;
		public var mouseJoint:b2MouseJoint;
		
		public function on_mouse_down():void {
			var body:b2Body = GetBodyAtMouse();
			if (body) {
				var mouse_joint:b2MouseJointDef = new b2MouseJointDef;
				mouse_joint.bodyA = world.GetGroundBody();
				mouse_joint.bodyB = body;
				mouse_joint.target.Set(_ns.mouseX/Config.WORLD_SCALE, _ns.mouseY/Config.WORLD_SCALE);
				mouse_joint.maxForce = 10000;
				//mouse_joint.timeStep = m_timeStep;
				mouseJoint = world.CreateJoint(mouse_joint) as b2MouseJoint;
			}
		}
		
		
		public function on_mouse_up():void {
			if (mouseJoint) {
				world.DestroyJoint(mouseJoint);
				mouseJoint = null;
			}
		}
		
		public function GetBodyAtMouse(includeStatic:Boolean=false):b2Body {
			real_x_mouse = (_ns.mouseX)/Config.WORLD_SCALE;
			real_y_mouse = (_ns.mouseY)/Config.WORLD_SCALE;
			mousePVec.Set(real_x_mouse, real_y_mouse);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(real_x_mouse - 0.001, real_y_mouse - 0.001);
			aabb.upperBound.Set(real_x_mouse + 0.001, real_y_mouse + 0.001);
			
			var body:b2Body = null;
			// Query the world for overlapping shapes.
			function GetBodyCallback(fixture:b2Fixture):Boolean
			{
				var shape:b2Shape = fixture.GetShape();
				if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
				{
					var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(), mousePVec);
					if (inside)
					{
						body = fixture.GetBody();
						return false;
					}
				}
				return true;
			}
			world.QueryAABB(GetBodyCallback, aabb);
			return body;
		}
	}
}