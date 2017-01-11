package states {
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.b2Body;
	import flash.geom.Point;
	import gameobjects.Grip;
	import gameobjects.Character;
	import core.Config;
	import managers.GripManager;
	import physics.PhysicsWorld;
	import states.IState;
	import gameobjects.BodyPartData;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	// Box2D is tuned for meters, kilograms, and seconds.

	public class Play extends Sprite implements IState {
		
		public static var _physicsWorld:PhysicsWorld = new PhysicsWorld();
		
		private var _character:Character = null;
		private var _gripManager:GripManager = null;
		
		private var _mouseJoint:b2MouseJoint;
		private var _heldBody:b2Body = null;
		
		public function Play():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			_gripManager = new GripManager(this);
			addChild(_gripManager)
			
			_character = new Character();
			addChild(_character);
		}
		
		public function update():IState {
			_gripManager.update(this.y);
			
			_physicsWorld.update();
			camera();
		
			for (var body:b2Body = _physicsWorld.GetBodyList(); body; body = body.GetNext()) {
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
			
			return null;
		}
		
		private function camera():void {
			var yPos:Number = _character.head.GetWorldCenter().y * Config.WORLD_SCALE;
			y = stage.stageHeight / 2 - yPos;
			
			//Reposition debug_sprite so debug sprites are aligned with starlings sprites. 
			_physicsWorld.debug_sprite.y = stage.stageHeight / 2 - yPos;
		}
		
		public function destroy():void {
			
		}
		
		public function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			
			if (touch) {
				var touchInPhysicsWorld:Point = touch.getLocation(this);
				touchInPhysicsWorld.x /= Config.WORLD_SCALE;
				touchInPhysicsWorld.y /= Config.WORLD_SCALE;
				
				if (touch.phase == TouchPhase.BEGAN) {
					onMouseDown(touchInPhysicsWorld);
				}
				else if (touch.phase == TouchPhase.ENDED) {
					onMouseUp();
				}
				else if (touch.phase == TouchPhase.MOVED) {
					onMouseMove(touchInPhysicsWorld);
				}
			}
		}
		
		public function onMouseDown(point:Point):void {
			var body:b2Body = _physicsWorld.GetMoveableBodyAtMouse(point);
			
			if (body) {
				_heldBody = body;
				_heldBody.SetType(b2Body.b2_dynamicBody);
				_mouseJoint = _physicsWorld.createMouseJoint(_heldBody, point);
			}
		}
		
		private function onMouseMove(atPoint:Point):void {
			if (_mouseJoint) {
				var p2:b2Vec2 = new b2Vec2(atPoint.x, atPoint.y);
				_mouseJoint.SetTarget(p2);
			}
		}
		
		public function onMouseUp():void {
			if (_mouseJoint) {
				_physicsWorld.DestroyJoint(_mouseJoint);
				_mouseJoint = null;
			}
			
			if (_heldBody && _physicsWorld.intersectsSensor(_heldBody)) {
				_heldBody.SetType(b2Body.b2_staticBody);
				_heldBody = null;
			}
		}
	}
}