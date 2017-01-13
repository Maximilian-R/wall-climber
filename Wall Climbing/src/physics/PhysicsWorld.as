package physics {
	
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	import starling.display.Sprite;
	
	import core.Config;
	import gameobjects.BodyPartData;
	import gameobjects.Grip;

	public class PhysicsWorld extends b2World {
		
		private var timeStep:Number;
		private var velocityIterations:Number;
		private var positionIterations:Number;
		
		private var _mouseJoint:b2MouseJoint;
		private var _heldBody:b2Body;
		private var _jointMaxForce:Number = 0;
		
		private var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/* Debugging var */
		private var _debugModeOn:Boolean = false;
		public var _debugger:Debugger;
		
		public function PhysicsWorld() {
			timeStep = 1.0 / Config.getNumber("physicsWorld", "timestep");
			velocityIterations = Config.getNumber("physicsWorld", "velIterations");
			positionIterations = Config.getNumber("physicsWorld", "posIterations");
			_jointMaxForce = Config.getNumber("physicsWorld", "maxJointForce");
			
			var gravity:b2Vec2 = new b2Vec2 (0.0, Config.getNumber("physicsWorld", "gravity"));
			var doSleep:Boolean = true;
			
			super(gravity, doSleep);
			
			/* Floor
			var groundBodyDef:b2BodyDef = new b2BodyDef();
			groundBodyDef.position.Set(0, Config.WORLD_HEIGHT / Config.WORLD_SCALE);
			groundBodyDef.type = b2Body.b2_staticBody;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(Config.WORLD_WIDTH / Config.WORLD_SCALE, (Config.WORLD_HEIGHT * 0.1) / Config.WORLD_SCALE );
			
			var groundBody:b2Body = this.CreateBody(groundBodyDef);
			groundBody.CreateFixture2(shape, 0.0); */ 
			
			if (_debugModeOn) {
				_debugger = new Debugger();
				SetDebugDraw(_debugger);
			}
		}
		
		public function update():void {
			Step(timeStep, velocityIterations, positionIterations);
			ClearForces();
			if (_debugModeOn) {
				DrawDebugData();
			}
			
			for (var body:b2Body = GetBodyList(); body; body = body.GetNext()) {
				if (body.GetUserData() is Grip) {
					
					var grip:Grip = body.GetUserData() as Grip;
					grip.y = body.GetPosition().y * Config.WORLD_SCALE;
				}
				if (body.GetUserData() is BodyPartData) {
					var data:BodyPartData = body.GetUserData() as BodyPartData;
					var sprite:Sprite = data.sprite;
					sprite.x = body.GetPosition().x * Config.WORLD_SCALE;
					sprite.y = body.GetPosition().y * Config.WORLD_SCALE;
					sprite.rotation = body.GetAngle();
				}
			}
		}
		
		private function isTouchingGrip(body:b2Body):Boolean {
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
		
		private function isGrabable(body:b2Body):Boolean {
			var data:* = body.GetUserData();
			if (data is BodyPartData) {
				var isMovable:Boolean = BodyPartData(data).isGrabable;
			}
			if (isMovable) {
				return true;
			} 
			return false;
		}
		
		private function getGrabableBodyAt(point:b2Vec2):b2Body {
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(point.x - 0.001, point.y - 0.001);
			aabb.upperBound.Set(point.x + 0.001, point.y + 0.001);
			
			var body:b2Body = null;
			function GetBodyCallback(fixture:b2Fixture):Boolean	{
				var shape:b2Shape = fixture.GetShape();
				var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(), point);
				if (inside && isGrabable(fixture.GetBody())) {
					body = fixture.GetBody();
					return false;
				}
				return true;
			}
			
			QueryAABB(GetBodyCallback, aabb);
			return body;
		}
		
		private function createMouseJoint(body:b2Body, target:b2Vec2):b2MouseJoint {
			var jointDef:b2MouseJointDef = new b2MouseJointDef();
			jointDef.bodyA = GetGroundBody();
			jointDef.bodyB = body;
			jointDef.target.Set(target.x, target.y);
			jointDef.maxForce = _jointMaxForce;
			return this.CreateJoint(jointDef) as b2MouseJoint;
		}
		
		public function mouseDown(point:b2Vec2):void {
			var body:b2Body = getGrabableBodyAt(point);
			
			if (body) {
				_heldBody = body;
				_heldBody.SetType(b2Body.b2_dynamicBody);
				_mouseJoint = createMouseJoint(_heldBody, point);
			}
		}
		
		public function mouseMove(point:b2Vec2):void {
			if (_mouseJoint) {
				_mouseJoint.SetTarget(point);
			}
		}
		
		public function mouseRelease():void {
			if (_mouseJoint) {
				DestroyJoint(_mouseJoint);
				_mouseJoint = null;
			}
			
			if (_heldBody && isTouchingGrip(_heldBody)) {
				_heldBody.SetType(b2Body.b2_staticBody);
				_heldBody = null;
				_dispatcher.dispatchEvent(new Event(Config.GRABBED_GRIP_EVENT));
			}
		}
		
		public function destroy():void {
			if (_debugModeOn) {
				_debugger.destroy();
			}
		}
		
		public function updateDebugSpritePos(y:Number):void {
			if (_debugModeOn) {
				_debugger.setDebugSpritePosition(y);
			}
		}
		
		public function addEventListener(type:String, listener:Function):void {
			_dispatcher.addEventListener(type, listener);
		}
	}
}