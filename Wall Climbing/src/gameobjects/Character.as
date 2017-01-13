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
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class Character extends Sprite {
		
		private var _maxStrength:Number;
		private var _strength:Number;
		private var _strengthDrain:Number;
		private var _percentageStrenght:Number;
		private var _physicsWorld:b2World;
		private var _grabableBodies:Vector.<b2Body> = new Vector.<b2Body>;
		
		private var _head:b2Body;
		private var _torso1:b2Body;
		
		public function Character(physicsWorld:b2World) {
			_physicsWorld = physicsWorld;
			setupDynamicBody();
			freezeTorso(true);
		}
		
		private function setupDynamicBody():void {
			_maxStrength = Config.getNumber("character", "maxStrength");
			_strength = _maxStrength;
			_strengthDrain =  Config.getNumber("character", "strengthDrain");
			_percentageStrenght = 100;
			
			
			var startX:Number = (Config.WORLD_WIDTH * 0.5) / Config.WORLD_SCALE;
			var startY:Number =  (Config.WORLD_HEIGHT * 0.5) / Config.WORLD_SCALE;
			
			var headRadius:Number = Config.getNumber("head", "radius") / Config.WORLD_SCALE;
			var torsoWitdh:Number = Config.getNumber("torso", "width") / Config.WORLD_SCALE;
			var torsoHeight:Number = Config.getNumber("torso", "height") / Config.WORLD_SCALE;
			var armWidth:Number = Config.getNumber("arm", "width") / Config.WORLD_SCALE;
			var armHeight:Number = Config.getNumber("arm", "height") / Config.WORLD_SCALE;
			var handWidth:Number = Config.getNumber("hand", "width") / Config.WORLD_SCALE;
			var handHeight:Number = Config.getNumber("hand", "height") / Config.WORLD_SCALE;
			var feetWidth:Number = Config.getNumber("foot", "width") / Config.WORLD_SCALE;
			var feetHeight:Number = Config.getNumber("foot", "height") / Config.WORLD_SCALE;
			var legWidth:Number = Config.getNumber("leg", "width") / Config.WORLD_SCALE;
			var legHeight:Number = Config.getNumber("leg", "height") / Config.WORLD_SCALE;
			
			var armMargin:Number = Config.getNumber("arm", "marginToBody") / Config.WORLD_SCALE;
			var legMargin:Number = Config.getNumber("leg", "marginToBody") / Config.WORLD_SCALE;
			
			var neckMargin:Number = Config.getNumber("head", "marginToBody") / Config.WORLD_SCALE;
			var torsoOverlap:Number = Config.getNumber("torso", "overlap") / Config.WORLD_SCALE;
			var shoulders:Number = Config.getNumber("torso", "shoulders") / Config.WORLD_SCALE;
			var handMargin:Number = Config.getNumber("hand", "marginToArm") / Config.WORLD_SCALE;
			var hipsMargin:Number = torsoHeight;
			
			/* ------------------------ BODY PARTS --------------------------- */
			
			_head = setupCircle(headRadius, startX, startY, Assets.HAIR_TEXTURE, false);
			_torso1 = setupBox(torsoWitdh, torsoHeight, startX, startY + neckMargin, Assets.RIBS_1_TEXTURE, false);
			var torso2:b2Body = setupBox(torsoWitdh, torsoHeight, startX, _torso1.GetPosition().y + torsoOverlap, Assets.RIBS_2_TEXTURE, false);
			var torso3:b2Body = setupBox(torsoWitdh, torsoHeight, startX, torso2.GetPosition().y + torsoOverlap, Assets.RIBS_3_TEXTURE, false);
			var upperLeftArm:b2Body = setupBox(armWidth, armHeight, startX - armMargin, _torso1.GetPosition().y - shoulders, Assets.UPPER_ARM_TEXTURE, false);
			var upperRightArm:b2Body = setupBox(armWidth, armHeight, startX + armMargin, _torso1.GetPosition().y - shoulders, Assets.UPPER_ARM_TEXTURE, false);
			var lowerLeftArm:b2Body = setupBox(armWidth, armHeight, startX - armMargin, upperLeftArm.GetPosition().y - armHeight, Assets.LOWER_ARM_TEXTURE, false);
			var lowerRightArm:b2Body = setupBox(armWidth, armHeight, startX + armMargin, upperLeftArm.GetPosition().y - armHeight, Assets.LOWER_ARM_TEXTURE, false);
			var upperLeftLeg:b2Body = setupBox(legWidth, legHeight, startX - legMargin, torso3.GetPosition().y + hipsMargin, Assets.UPPER_LEG_TEXTURE, false);
			var upperRightLeg:b2Body = setupBox(legWidth, legHeight, startX + legMargin, torso3.GetPosition().y + hipsMargin, Assets.UPPER_LEG_TEXTURE, false);
			var lowerLeftLeg:b2Body = setupBox(legWidth, legHeight, startX - legMargin, upperLeftLeg.GetPosition().y + legHeight, Assets.LOWER_LEG_TEXTURE, false);
			var lowerRightLeg:b2Body = setupBox(legWidth, legHeight, startX + legMargin, upperLeftLeg.GetPosition().y + legHeight, Assets.LOWER_LEG_TEXTURE, false);
			var leftHand:b2Body = setupBox(handWidth, handHeight, startX - armMargin, lowerLeftArm.GetPosition().y - handMargin, Assets.HAND_TEXTURE, true);
			var rightHand:b2Body = setupBox(handWidth, handHeight, startX + armMargin, lowerLeftArm.GetPosition().y - handMargin, Assets.HAND_TEXTURE, true);
			var leftFoot:b2Body = setupBox(feetWidth, feetHeight, startX - feetWidth/2, lowerLeftLeg.GetPosition().y + (legHeight * 0.5), Assets.FOOT_TEXTURE, true);
			var rightFoot:b2Body = setupBox(feetWidth, feetHeight, startX + feetWidth/2, lowerLeftLeg.GetPosition().y + (legHeight * 0.5), Assets.FOOT_TEXTURE, true, true);
			
			_grabableBodies.push(leftFoot, rightFoot, rightHand, leftHand);
			
			/* ------------------------ Joints --------------------------- */
			
			
			
			setupJoint( -40, 40, _head, _torso1, startX, startY + neckMargin/2);
			setupJoint( -15, 15, _torso1, torso2, startX, startY + (80 / Config.WORLD_SCALE));
			setupJoint( -15, 15, torso2, torso3, startX, startY + (110 / Config.WORLD_SCALE));
			
			setupJoint( -180, 60, _torso1, upperLeftArm, startX - armMargin, startY + (30 / Config.WORLD_SCALE));
			setupJoint( -60, 180, _torso1, upperRightArm, startX + armMargin, startY + (30 / Config.WORLD_SCALE));
			setupJoint( -1, 180, upperLeftArm, lowerLeftArm, startX - armMargin, startY - (20 / Config.WORLD_SCALE));
			setupJoint( -180, 1, upperRightArm, lowerRightArm,startX + armMargin, startY - (20 / Config.WORLD_SCALE));
			setupJoint( -20, 20, leftHand, lowerLeftArm, startX - armMargin, startY - (70 / Config.WORLD_SCALE));
			setupJoint( -20, 20, rightHand, lowerRightArm, startX + armMargin, startY - (70 / Config.WORLD_SCALE));
			setupJoint( -140, 1, upperLeftLeg, torso3, startX - legMargin, startY + (120 / Config.WORLD_SCALE));
			setupJoint( -1, 140, upperRightLeg, torso3, startX + legMargin, startY + (120 / Config.WORLD_SCALE));
			setupJoint( -1, 100, lowerLeftLeg, upperLeftLeg, startX - legMargin, startY + (170 / Config.WORLD_SCALE));
			setupJoint( -100, 1, lowerRightLeg, upperRightLeg, startX + legMargin, startY + (170 / Config.WORLD_SCALE));
			setupJoint( -20, 60, leftFoot, lowerLeftLeg, startX - legMargin, startY + (235 / Config.WORLD_SCALE));
			setupJoint( -60, 20, rightFoot, lowerRightLeg, startX + legMargin, startY + (235 / Config.WORLD_SCALE));
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
		
		private function setupJoint(lowerAngle:Number, upperAngle:Number, bodyA:b2Body, bodyB:b2Body, anchorX:Number, anchorY:Number):void {
			var anchor:b2Vec2 = new b2Vec2(anchorX, anchorY);
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.enableLimit = true;
			jointDef.lowerAngle = lowerAngle/ (180 / Math.PI);
			jointDef.upperAngle = upperAngle / (180 / Math.PI);
			jointDef.Initialize(bodyA, bodyB, anchor);
			_physicsWorld.CreateJoint(jointDef);
		}
		
		public function freezeTorso(on:Boolean):void {
			if (on) {
				_torso1.SetType(b2Body.b2_staticBody);
			} else {
				_torso1.SetType(b2Body.b2_dynamicBody);
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
		
		public function getWorldCenterY():Number {
			return _head.GetWorldCenter().y
		}
	}
}