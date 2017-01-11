package physics {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import core.Config;
	import gameobjects.BodyPartData;
	import gameobjects.Grip;
	import managers.ContactManager;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import starling.core.Starling;

	public class PhysicsWorld extends b2World {
		private var timeStep:Number = 1.0 / 30;
		private var velocityIterations:Number = 10;
		private var positionIterations:Number = 10;
		private var _ns:Stage = Starling.current.nativeStage;
		public var debug_sprite:flash.display.Sprite = new flash.display.Sprite();
		
		private var _cm:ContactManager = new ContactManager();
		
		public function PhysicsWorld() {
			//Setup World Object	
			var gravity:b2Vec2 = new b2Vec2 (0.0, Config.PHYSICS_GRAVITY);
			var doSleep:Boolean = true;
			
			super(gravity, doSleep);
			this.SetContactListener(_cm);
			this.SetContactFilter(new ContactFilter());
			
			//Create ground body 
			var groundBodyDef:b2BodyDef = new b2BodyDef();
			groundBodyDef.position.Set(0, Config.WORLD_HEIGHT / Config.WORLD_SCALE);
			groundBodyDef.type = b2Body.b2_staticBody;
			
			//Set a shape (fixture) and create it
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(Config.WORLD_WITDH / Config.WORLD_SCALE, (Config.WORLD_HEIGHT * 0.1) / Config.WORLD_SCALE );
			
			//Let world create the body
			var groundBody:b2Body = this.CreateBody(groundBodyDef);
			groundBody.CreateFixture2(shape, 0.0);
			
			//debug_draw();
		}
		
		public function update():void {
			// Box2D world update
			Step(timeStep, velocityIterations, positionIterations);
			ClearForces();
			DrawDebugData();
		}
		
		public function debug_draw():void {
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			
			_ns.addChild(debug_sprite);
			debug_draw.SetSprite(debug_sprite);
			debug_draw.SetDrawScale(Config.WORLD_SCALE);
			debug_draw.SetFlags(b2DebugDraw.e_shapeBit);
			debug_draw.AppendFlags(b2DebugDraw.e_jointBit);
			debug_draw.SetFillAlpha(0.3);
			debug_draw.SetLineThickness(2.0);
			
			SetDebugDraw(debug_draw);
		}
		
		public function intersectsSensor(body:b2Body):Boolean {
			for (var cE:b2ContactEdge = body.GetContactList(); cE; cE = cE.next) {
				var contact:b2Contact = cE.contact;
				if (contact.GetFixtureA().GetBody().GetUserData() is Grip && contact.IsTouching()) {
					return true;
				} else if (contact.GetFixtureB().GetBody().GetUserData() is Grip && contact.IsTouching()) {
					return true;
				}
			}
			return false;
		}
		
		public function GetMoveableBodyAtMouse(atPoint:Point):b2Body {
			var mouseVec:b2Vec2 = new b2Vec2(atPoint.x, atPoint.y);
			
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(atPoint.x - 0.001, atPoint.y - 0.001);
			aabb.upperBound.Set(atPoint.x + 0.001, atPoint.y + 0.001);
			
			var body:b2Body = null;
			function GetBodyCallback(fixture:b2Fixture):Boolean	{
				var shape:b2Shape = fixture.GetShape();
				var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(), mouseVec);
				if (inside && checkIfGrabable(fixture.GetBody())) {
					body = fixture.GetBody();
					return false;
				}
				return true;
			}
			
			QueryAABB(GetBodyCallback, aabb);
			return body;
		}
		
		public function createMouseJoint(body:b2Body, target:Point):b2MouseJoint {
			var jointDef:b2MouseJointDef = new b2MouseJointDef();
			jointDef.bodyA = this.GetGroundBody();
			jointDef.bodyB = body;
			jointDef.target.Set(target.x, target.y);
			jointDef.maxForce = 5000;
			return this.CreateJoint(jointDef) as b2MouseJoint;
		}
		
		private function checkIfGrabable(body:b2Body):Boolean {
			var data:* = body.GetUserData();
			if (data is BodyPartData) {
				var isMovable:Boolean = BodyPartData(data).isGrabable;
			}
			if (isMovable) {
				return true;
			} 
			return false;
		}
	}
}