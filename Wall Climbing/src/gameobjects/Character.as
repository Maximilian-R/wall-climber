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
	import core.Assets;
	import core.Config;
	import states.Play;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class Character extends Sprite {
		
		public function Character() {
			setupDynamicBody();
		}
		
		public var head:b2Body;
		
		private function setupDynamicBody():void {
			
			var startX:Number = (Config.WORLD_WITDH * 0.5) / Config.WORLD_SCALE;
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
			
			var torso1:b2Body = setupBox(torsoWitdh, torsoHeight, startX, startY + neckMargin, Assets.RIBS_1_TEXTURE, false);
			var torso2:b2Body = setupBox(torsoWitdh, torsoHeight, startX, torso1.GetPosition().y + torsoOverlap, Assets.RIBS_2_TEXTURE, false);
			var torso3:b2Body = setupBox(torsoWitdh, torsoHeight, startX, torso2.GetPosition().y + torsoOverlap, Assets.RIBS_3_TEXTURE, false);
			
			var upperLeftArm:b2Body = setupBox(armWidth, armHeight, startX - armMargin, torso1.GetPosition().y - shoulders, Assets.LEG_TEXTURE, false);
			var upperRightArm:b2Body = setupBox(armWidth, armHeight, startX + armMargin, torso1.GetPosition().y - shoulders, Assets.LEG_TEXTURE, false);
			var lowerLeftArm:b2Body = setupBox(armWidth, armHeight, startX - armMargin, upperLeftArm.GetPosition().y - armHeight, Assets.LEG_TEXTURE, false);
			var lowerRightArm:b2Body = setupBox(armWidth, armHeight, startX + armMargin, upperLeftArm.GetPosition().y - armHeight, Assets.LEG_TEXTURE, false);
			
			var	leftHand:b2Body = setupBox(handWidth, handWidth, startX - armMargin, lowerLeftArm.GetPosition().y - handMargin, Assets.HAND_TEXTURE, true);
			var	rightHand:b2Body = setupBox(handWidth, handWidth, startX + armMargin, lowerLeftArm.GetPosition().y - handMargin, Assets.HAND_TEXTURE, true);
			
			var upperLeftLeg:b2Body = setupBox(legWidth, legHeight, startX - legMargin, torso3.GetPosition().y + hipsMargin, Assets.LEG_TEXTURE, false);
			var upperRightLeg:b2Body = setupBox(legWidth, legHeight, startX + legMargin, torso3.GetPosition().y + hipsMargin, Assets.LEG_TEXTURE, false);
			var lowerLeftLeg:b2Body = setupBox(legWidth, legHeight, startX - legMargin, upperLeftLeg.GetPosition().y + legHeight, Assets.LEG_TEXTURE, false);
			var lowerRightLeg:b2Body = setupBox(legWidth, legHeight, startX + legMargin, upperLeftLeg.GetPosition().y + legHeight, Assets.LEG_TEXTURE, false);
			
			var leftFoot:b2Body = setupBox(feetWidth, feetHeight, startX - (20 / Config.WORLD_SCALE), lowerLeftLeg.GetPosition().y + (legHeight * 0.5), Assets.HAND_TEXTURE, true);
			var rightFoot:b2Body = setupBox(feetWidth, feetHeight, startX + (20 / Config.WORLD_SCALE), lowerLeftLeg.GetPosition().y + (legHeight * 0.5), Assets.HAND_TEXTURE, true);
			
			
			/* ------------------------ Joints --------------------------- */
			
			setupJoint( -40, 40, head, torso1, new b2Vec2(startX, startY + (20 / Config.WORLD_SCALE)));
			setupJoint( -15, 15, torso1, torso2, new b2Vec2(startX, startY + (80 / Config.WORLD_SCALE)));
			setupJoint( -15, 15, torso2, torso3, new b2Vec2(startX, startY + (110 / Config.WORLD_SCALE)));
			setupJoint( -180, 60, torso1, upperLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY + (30 / Config.WORLD_SCALE)));
			setupJoint( -60, 180, torso1, upperRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY + (30 / Config.WORLD_SCALE)));
			setupJoint( -1, 180, upperLeftArm, lowerLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY - (20 / Config.WORLD_SCALE)));
			setupJoint( -180, 1, upperRightArm, lowerRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY - (20 / Config.WORLD_SCALE)));
			setupJoint( -40, 40, leftHand, lowerLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY - (70 / Config.WORLD_SCALE)));
			setupJoint( -40, 40, rightHand, lowerRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY - (70 / Config.WORLD_SCALE)));
			setupJoint( -60, 1, upperLeftLeg, torso3, new b2Vec2(startX - (10 / Config.WORLD_SCALE), startY + (120 / Config.WORLD_SCALE)));
			setupJoint( -1, 60, upperRightLeg, torso3, new b2Vec2(startX + (10 / Config.WORLD_SCALE), startY + (120 / Config.WORLD_SCALE)));
			setupJoint( -40, 100, lowerLeftLeg, upperLeftLeg, new b2Vec2(startX - (10 / Config.WORLD_SCALE), startY + (170 / Config.WORLD_SCALE)));
			setupJoint( -100, 40, lowerRightLeg, upperRightLeg, new b2Vec2(startX + (10 / Config.WORLD_SCALE), startY + (170 / Config.WORLD_SCALE)));
			setupJoint( -1, 1, leftFoot, lowerLeftLeg, new b2Vec2(startX - (15 / Config.WORLD_SCALE), startY + (235 / Config.WORLD_SCALE)));
			setupJoint( -1, 1, rightFoot, lowerRightLeg, new b2Vec2(startX + (15 / Config.WORLD_SCALE), startY + (235 / Config.WORLD_SCALE)));
			
			
			/* ------------------------- USER DATA ------------------------------- */
			
		}
		
		private function setData(body:b2Body, texture:Texture, width: Number, height:Number, isGrabable:Boolean):void {
			var sprite:Sprite = new Sprite();
			var image:Image = new Image(texture);
			image.alignPivot();
			image.width = (width + 0.5)* Config.WORLD_SCALE;
			image.height = (height + 0.5) * Config.WORLD_SCALE;
			sprite.addChild(image);
			this.addChild(sprite);
			
			var data:BodyPartData = new BodyPartData(sprite, isGrabable);
			body.SetUserData(data);
		}
		
		private function setupCircle(radius:Number, x:Number, y:Number, texture:Texture, isGrabable:Boolean):b2Body {
			var circle:b2CircleShape = new b2CircleShape(radius * 0.5);
			
			var body:b2Body = Play._physicsWorld.CreateBody(getBodyDef(x, y));
			body.CreateFixture(getFixture(circle));
			
			setData(body, texture,radius, radius, isGrabable);
			
			return body;
		}
		
		private function setupBox(width:Number, height:Number, x:Number, y:Number, texture:Texture, isGrabable:Boolean):b2Body {
			var box:b2PolygonShape = new b2PolygonShape();
			
			//SetAsBox takes half width/height as parameter
			box.SetAsBox(width * 0.5, height * 0.5);
			
			var body:b2Body = Play._physicsWorld.CreateBody(getBodyDef(x, y));
			body.CreateFixture(getFixture(box));
			
			setData(body, texture, width, height, isGrabable);
			
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
			Play._physicsWorld.CreateJoint(jointDef);
		}
		
		
	}
}