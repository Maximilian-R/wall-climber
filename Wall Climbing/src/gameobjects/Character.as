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
		private var _startX:Number = (Config.WORLD_WIDTH * 0.5) / Config.WORLD_SCALE;
		private var _startY:Number =  (Config.WORLD_HEIGHT * 0.5) / Config.WORLD_SCALE;
		
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
			
			/* ------------------------ BODY PARTS --------------------------- */
			_head = setupCircle("head");
			_torso1 = setupBox("torso1");
			var torso2:b2Body = setupBox("torso2");
			var torso3:b2Body = setupBox("torso3");
			var upperLeftArm:b2Body = setupBox("leftUpperArm");
			var lowerLeftArm:b2Body = setupBox("leftLowerArm");
			var upperRightArm:b2Body = setupBox("rightUpperArm");
			var lowerRightArm:b2Body = setupBox("rightLowerArm");
			var upperLeftLeg:b2Body = setupBox("leftUpperLeg");
			var lowerLeftLeg:b2Body = setupBox("leftLowerLeg");
			var upperRightLeg:b2Body = setupBox("rightUpperLeg");
			var lowerRightLeg:b2Body = setupBox("rightLowerLeg");
			var leftHand:b2Body = setupBox("leftHand");
			var rightHand:b2Body = setupBox("rightHand");
			var leftFoot:b2Body = setupBox("leftFoot");
			var rightFoot:b2Body = setupBox("rightFoot");
			
			_grabableBodies.push(leftFoot, rightFoot, rightHand, leftHand);
			
			/* ------------------------ Joints --------------------------- */
			setupJoint( "neckJoint", true, _head, _torso1);
			setupJoint( "torsoJoint1", true, _torso1, torso2);
			setupJoint( "torsoJoint2", true, torso2, torso3);
			setupJoint( "shoulderJoint", true, _torso1, upperLeftArm);
			setupJoint( "shoulderJoint", false, _torso1, upperRightArm);
			setupJoint( "elbowJoint", true, upperLeftArm, lowerLeftArm);
			setupJoint( "elbowJoint", false, upperRightArm, lowerRightArm);
			setupJoint( "wristJoint", true, leftHand, lowerLeftArm);
			setupJoint( "wristJoint", false, rightHand, lowerRightArm);
			setupJoint( "hipJoint", true, upperLeftLeg, torso3);
			setupJoint( "hipJoint", false, upperRightLeg, torso3);
			setupJoint( "kneeJoint", true, lowerLeftLeg, upperLeftLeg);
			setupJoint( "kneeJoint", false, lowerRightLeg, upperRightLeg);
			setupJoint( "ankleJoint", true, leftFoot, lowerLeftLeg);
			setupJoint( "ankleJoint", false, rightFoot, lowerRightLeg);
		}
		
		public function setupBox(name:String):b2Body {
			var width:Number = Config.getNumber(name, "width") / Config.WORLD_SCALE;
			var height:Number = Config.getNumber(name, "height") / Config.WORLD_SCALE;
			
			var box:b2PolygonShape = new b2PolygonShape();
			box.SetAsBox(width * 0.5, height * 0.5);
			
			return setupBody(box, name);
		}
		
		public function setupCircle(name:String):b2Body {
			var radius:Number = Config.getNumber(name, "radius") / Config.WORLD_SCALE;				
			var circle:b2CircleShape = new b2CircleShape(radius * 0.5);
			
			return setupBody(circle, name);
		}
		
		private function setupBody(shape:b2Shape, name:String):b2Body {
			var xValue:Number = _startX + (Config.getNumber(name, "x") / Config.WORLD_SCALE);
			var yValue:Number = _startY + (Config.getNumber(name, "y") / Config.WORLD_SCALE);
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(xValue, yValue);
			bodyDef.type = b2Body.b2_dynamicBody;
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 20.0;
			fixtureDef.friction = 0.3;
			fixtureDef.restitution = 0.0;
			fixtureDef.shape = shape;
			
			var body:b2Body = _physicsWorld.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			setData(body, name);
			
			return body;
		}
		
		private function setData(body:b2Body, name:String):void {
			var width:Number = Config.getNumber(name, "width");
			var height:Number = Config.getNumber(name, "height");
			var textureName:String = Config.getString(name, "texture");
			var texture:Texture = Assets.TEXTURE_ATLAS.getTexture(textureName);
			var grabable:Boolean = Config.getBool(name, "grabable");
			var invertTexture:Boolean = Config.getBool(name, "invertTexture");
			
			var sprite:Sprite = new Sprite();
			var image:Image = new Image(texture);
			image.alignPivot();
			image.width = width;
			image.height = height;
			image.useHandCursor = grabable;
			if (invertTexture) {
				image.scaleX *= -1
			}
			
			sprite.addChild(image);
			this.addChild(sprite);
			
			var data:BodyPartData = new BodyPartData(sprite, grabable);
			body.SetUserData(data);
		}
		
		private function setupJoint(jointName:String, left:Boolean, bodyA:b2Body, bodyB:b2Body):void {
			var lowerLimit:Number = Config.getNumber(jointName, "lowerLimit") / (180 / Math.PI);
			var upperLimit:Number = Config.getNumber(jointName, "upperLimit") / (180 / Math.PI);
			
			var anchorX:Number;
			var anchorY:Number = _startY + (Config.getNumber(jointName, "y") / Config.WORLD_SCALE);
			
			var xValue:Number = Config.getNumber(jointName, "x") / Config.WORLD_SCALE;
			if (left) {
				anchorX = _startX - xValue;
			} else {
				anchorX = _startX + xValue;
			}
			
			var anchor:b2Vec2 = new b2Vec2(anchorX, anchorY);
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.enableLimit = true;
			
			if (left) {
				jointDef.lowerAngle = -lowerLimit;
				jointDef.upperAngle = upperLimit;
			} else {
				jointDef.lowerAngle = -upperLimit;
				jointDef.upperAngle = lowerLimit;
			}
			
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