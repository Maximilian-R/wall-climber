package gameobjects {
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2Bound;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import core.Assets;
	import core.Config;
	import physics.PhysicsWorld;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import states.PlayState;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class Character extends Sprite {
		
		private var _maxStrength:Number = 5000;
		private var _strength:Number = _maxStrength;
		private var _strengthDrain:Number = 1;
		private var _percentageStrenght:Number = 100;
		
		private var _physicsWorld:b2World;
		private var torso1:b2Body;
		
		private var leftFoot:b2Body;
		private var rightFoot:b2Body;
		private var	leftHand:b2Body;
		private var	rightHand:b2Body;
		
		private var _dispatcher:EventDispatcher = new EventDispatcher();
		
		private var _grabableBodies:Vector.<b2Body> = new Vector.<b2Body>;
		
		public var head:b2Body;
		
		public function Character(physicsWorld:b2World) {
			_physicsWorld = physicsWorld;
			setupDynamicBody();
			freezeTorso(true);
		}
		
		private function setupDynamicBody():void {
			
			var startX:Number = (Config.WORLD_WIDTH * 0.5) / Config.WORLD_SCALE;
			var startY:Number =  (Config.WORLD_HEIGHT * 0.5) / Config.WORLD_SCALE;
			
			var headRadius:Number = 40 / Config.WORLD_SCALE;
			var torsoWitdh:Number = 50 / Config.WORLD_SCALE;
			var torsoHeight:Number = 40 / Config.WORLD_SCALE;
			var armWidth:Number = 20 / Config.WORLD_SCALE;
			var armHeight:Number = 50 / Config.WORLD_SCALE;
			var handWidth:Number = 20 / Config.WORLD_SCALE;
			var feetWidth:Number = 40 / Config.WORLD_SCALE;
			var feetHeight:Number = 20 / Config.WORLD_SCALE;
			var legWidth:Number = 25 / Config.WORLD_SCALE;
			var legHeight:Number = 60 / Config.WORLD_SCALE;
			var armMargin:Number = 20 / Config.WORLD_SCALE;
			var legMargin:Number = 12.5 / Config.WORLD_SCALE;
			
			var neckMargin:Number = headRadius * 1.25;
			var torsoOverlap:Number = torsoHeight * 0.75;
			var shoulders:Number = torsoHeight * 0.80;
			var handMargin:Number = handWidth * 2;
			var hipsMargin:Number = torsoHeight * 1;
			
			/* ------------------------ BODY PARTS --------------------------- */
			
			head = setupCircle(headRadius, startX, startY, Assets.HAIR_TEXTURE, false);
			
			torso1 = setupBox(torsoWitdh, torsoHeight, startX, startY + neckMargin, Assets.RIBS_1_TEXTURE, false);
			var torso2:b2Body = setupBox(torsoWitdh, torsoHeight, startX, torso1.GetPosition().y + torsoOverlap, Assets.RIBS_2_TEXTURE, false);
			var torso3:b2Body = setupBox(torsoWitdh, torsoHeight, startX, torso2.GetPosition().y + torsoOverlap, Assets.RIBS_3_TEXTURE, false);
			
			var upperLeftArm:b2Body = setupBox(armWidth, armHeight, startX - armMargin, torso1.GetPosition().y - shoulders, Assets.UPPER_ARM_TEXTURE, false);
			var upperRightArm:b2Body = setupBox(armWidth, armHeight, startX + armMargin, torso1.GetPosition().y - shoulders, Assets.UPPER_ARM_TEXTURE, false);
			var lowerLeftArm:b2Body = setupBox(armWidth, armHeight, startX - armMargin, upperLeftArm.GetPosition().y - armHeight, Assets.LOWER_ARM_TEXTURE, false);
			var lowerRightArm:b2Body = setupBox(armWidth, armHeight, startX + armMargin, upperLeftArm.GetPosition().y - armHeight, Assets.LOWER_ARM_TEXTURE, false);
			
			
			
			var upperLeftLeg:b2Body = setupBox(legWidth, legHeight, startX - legMargin, torso3.GetPosition().y + hipsMargin, Assets.UPPER_LEG_TEXTURE, false);
			var upperRightLeg:b2Body = setupBox(legWidth, legHeight, startX + legMargin, torso3.GetPosition().y + hipsMargin, Assets.UPPER_LEG_TEXTURE, false);
			var lowerLeftLeg:b2Body = setupBox(legWidth, legHeight, startX - legMargin, upperLeftLeg.GetPosition().y + legHeight, Assets.LOWER_LEG_TEXTURE, false);
			var lowerRightLeg:b2Body = setupBox(legWidth, legHeight, startX + legMargin, upperLeftLeg.GetPosition().y + legHeight, Assets.LOWER_LEG_TEXTURE, false);
			
			
			leftHand = setupBox(handWidth, handWidth, startX - armMargin, lowerLeftArm.GetPosition().y - handMargin, Assets.HAND_TEXTURE, true);
			rightHand = setupBox(handWidth, handWidth, startX + armMargin, lowerLeftArm.GetPosition().y - handMargin, Assets.HAND_TEXTURE, true);
			leftFoot = setupBox(feetWidth, feetHeight, startX - (20 / Config.WORLD_SCALE), lowerLeftLeg.GetPosition().y + (legHeight * 0.5), Assets.FOOT_TEXTURE, true);
			rightFoot = setupBox(feetWidth, feetHeight, startX + (20 / Config.WORLD_SCALE), lowerLeftLeg.GetPosition().y + (legHeight * 0.5), Assets.FOOT_TEXTURE, true, true);
			
			
			_grabableBodies.push(leftFoot, rightFoot, rightHand, leftHand);
			
			/* ------------------------ Joints --------------------------- */
			
			setupJoint( -40, 40, head, torso1, new b2Vec2(startX, startY + (20 / Config.WORLD_SCALE)));
			setupJoint( -15, 15, torso1, torso2, new b2Vec2(startX, startY + (80 / Config.WORLD_SCALE)));
			setupJoint( -15, 15, torso2, torso3, new b2Vec2(startX, startY + (110 / Config.WORLD_SCALE)));
			setupJoint( -180, 60, torso1, upperLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY + (30 / Config.WORLD_SCALE)));
			setupJoint( -60, 180, torso1, upperRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY + (30 / Config.WORLD_SCALE)));
			setupJoint( -1, 180, upperLeftArm, lowerLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY - (20 / Config.WORLD_SCALE)));
			setupJoint( -180, 1, upperRightArm, lowerRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY - (20 / Config.WORLD_SCALE)));
			setupJoint( -20, 20, leftHand, lowerLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY - (70 / Config.WORLD_SCALE)));
			setupJoint( -20, 20, rightHand, lowerRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY - (70 / Config.WORLD_SCALE)));
			setupJoint( -140, 1, upperLeftLeg, torso3, new b2Vec2(startX - (10 / Config.WORLD_SCALE), startY + (120 / Config.WORLD_SCALE)));
			setupJoint( -1, 140, upperRightLeg, torso3, new b2Vec2(startX + (10 / Config.WORLD_SCALE), startY + (120 / Config.WORLD_SCALE)));
			setupJoint( -1, 100, lowerLeftLeg, upperLeftLeg, new b2Vec2(startX - (10 / Config.WORLD_SCALE), startY + (170 / Config.WORLD_SCALE)));
			setupJoint( -100, 1, lowerRightLeg, upperRightLeg, new b2Vec2(startX + (10 / Config.WORLD_SCALE), startY + (170 / Config.WORLD_SCALE)));
			setupJoint( -1, 1, leftFoot, lowerLeftLeg, new b2Vec2(startX - (15 / Config.WORLD_SCALE), startY + (235 / Config.WORLD_SCALE)));
			setupJoint( -1, 1, rightFoot, lowerRightLeg, new b2Vec2(startX + (15 / Config.WORLD_SCALE), startY + (235 / Config.WORLD_SCALE)));
		}
		
		private function setData(body:b2Body, texture:Texture, width: Number, height:Number, isGrabable:Boolean, invertTexture:Boolean = false):void {
			var sprite:Sprite = new Sprite();
			var image:Image = new Image(texture);
			image.alignPivot();
			image.width = width * Config.WORLD_SCALE;
			image.height = height * Config.WORLD_SCALE;
			
			if (invertTexture) {
				image.scaleX *= -1
			}
			
			sprite.addChild(image);
			this.addChild(sprite);
			
			var data:BodyPartData = new BodyPartData(sprite, isGrabable);
			body.SetUserData(data);
		}
		
		private function setupCircle(radius:Number, x:Number, y:Number, texture:Texture, isGrabable:Boolean):b2Body {
			var circle:b2CircleShape = new b2CircleShape(radius * 0.5);
			
			var body:b2Body = _physicsWorld.CreateBody(getBodyDef(x, y));
			body.CreateFixture(getFixture(circle));
			
			setData(body, texture,radius, radius, isGrabable);
			
			return body;
		}
		
		private function setupBox(width:Number, height:Number, x:Number, y:Number, texture:Texture, isGrabable:Boolean, invertTexture:Boolean = false):b2Body {
			var box:b2PolygonShape = new b2PolygonShape();
			
			//SetAsBox takes half width/height as parameter
			box.SetAsBox(width * 0.5, height * 0.5);
			
			var body:b2Body = _physicsWorld.CreateBody(getBodyDef(x, y));
			body.CreateFixture(getFixture(box));
			
			setData(body, texture, width, height, isGrabable, invertTexture);
			
			return body;
		}
		
		private function getBodyDef(x:Number, y:Number):b2BodyDef {
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x, y);
			bodyDef.type = b2Body.b2_dynamicBody;
			return bodyDef;
		}
		
		private function getFixture(shape:b2Shape):b2FixtureDef {
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 20.0;
			fixtureDef.friction = 0.3;
			fixtureDef.restitution = 0.0;
			fixtureDef.shape = shape;
			return fixtureDef;
		}
		
		private function setupJoint(lowerAngle:Number, upperAngle:Number, bodyA:b2Body, bodyB:b2Body, anchor:b2Vec2):void {
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.enableLimit = true;
			jointDef.lowerAngle = lowerAngle/ (180 / Math.PI);
			jointDef.upperAngle = upperAngle / (180 / Math.PI);
			jointDef.Initialize(bodyA, bodyB, anchor);
			_physicsWorld.CreateJoint(jointDef);
		}
		
		public function freezeTorso(on:Boolean):void {
			if (on) {
				torso1.SetType(b2Body.b2_staticBody);
			} else {
				torso1.SetType(b2Body.b2_dynamicBody);
			}
		}
		
		public function update():void {
			var staticBodies:Number = grabableStaticBodies();
			if (staticBodies == 0) {
				fall();
			}
			
			var drainMultiplicator:Number = _grabableBodies.length - staticBodies;
			if (drainMultiplicator == _grabableBodies.length) {
				drainMultiplicator = 0;
			}
			_strength -= _strengthDrain * drainMultiplicator;
			
			if (_strength < 0) {
				fall();
			}
			
			var percentStrength:int = int((_strength / _maxStrength) * 100);
			if (percentStrength < _percentageStrenght) {
				_percentageStrenght = percentStrength;
				dispatchEvent(new Event(Config.STRENGHT_PERCENTAGE_CHANGED));
			}
		}
		
		public function fall():void {
			for each (var body:b2Body in _grabableBodies) {
				body.SetType(b2Body.b2_dynamicBody);
			}
		}
		
		public function grabableStaticBodies():Number {
			var count:Number = 0;
			for each (var body:b2Body in _grabableBodies) {
				if (body.GetType() == b2Body.b2_staticBody) {
					count++;
				}
			}
			return count;
		}
		
		public function getPercentageStrentgh():Number {
			return _percentageStrenght;
		}
	}
}