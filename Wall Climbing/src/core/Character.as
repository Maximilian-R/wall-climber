package core {
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.b2Bound;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import starling.display.Sprite;

	public class Character extends Sprite {
		
		public function Character() {
			setupDynamicBody();
		}
		
		
		private function setupDynamicBody():void {
			var headRadius:Number = 20;
			var torsoWitdh:Number = 25;
			var torsoHeight:Number = 20;
			var armWidth:Number = 10;
			var armHeight:Number = 25;
			var handWidth:Number = 10;
			var feetWidth:Number = 20;
			var feetHeight:Number = 5;
			var legWidth:Number = 12.5;
			var legHeight:Number = 30;
			
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			
			var circle:b2CircleShape;
			var box:b2PolygonShape;
			
			// Define initial position of charachter build
			var startX:Number = (Config.WORLD_WITDH * 0.5) / Config.WORLD_SCALE;
			var startY:Number =  (Config.WORLD_HEIGHT * 0.5) / Config.WORLD_SCALE;
			
			// Common
			bodyDef.type = b2Body.b2_dynamicBody;
			fixtureDef.density = 1.0;
			fixtureDef.friction = 0.3;
			fixtureDef.restitution = 0.0;
			
			// Head
			circle = new b2CircleShape(headRadius / Config.WORLD_SCALE);
			fixtureDef.shape = circle;
			bodyDef.position.Set(startX, startY);
			var head:b2Body = Play.world.CreateBody(bodyDef);
			head.CreateFixture(fixtureDef);
			
			// Common Torso
			box = new b2PolygonShape();
			box.SetAsBox(torsoWitdh / Config.WORLD_SCALE, torsoHeight / Config.WORLD_SCALE);
			fixtureDef.shape = box;
			
			// Torso1	
			bodyDef.position.Set(startX, startY + (50 / Config.WORLD_SCALE));
			var torso1:b2Body = Play.world.CreateBody(bodyDef);
			torso1.CreateFixture(fixtureDef);
			// Torso2	
			bodyDef.position.Set(startX, startY + (80 / Config.WORLD_SCALE));
			var torso2:b2Body = Play.world.CreateBody(bodyDef);
			torso2.CreateFixture(fixtureDef);
			// Torso3	
			bodyDef.position.Set(startX, startY + (110 / Config.WORLD_SCALE));
			var torso3:b2Body = Play.world.CreateBody(bodyDef);
			torso3.CreateFixture(fixtureDef);
			
			// Common Arm
			box = new b2PolygonShape();
			box.SetAsBox(armWidth / Config.WORLD_SCALE , armHeight / Config.WORLD_SCALE);
			fixtureDef.shape = box;
			
			// Upper Arm
			//Left
			bodyDef.position.Set(startX - (20 / Config.WORLD_SCALE), startY + (10 / Config.WORLD_SCALE));
			var upperLeftArm:b2Body = Play.world.CreateBody(bodyDef);
			upperLeftArm.CreateFixture(fixtureDef);
			//Right
			bodyDef.position.Set(startX + (20 / Config.WORLD_SCALE), startY + (10 / Config.WORLD_SCALE));
			var upperRightArm:b2Body = Play.world.CreateBody(bodyDef);
			upperRightArm.CreateFixture(fixtureDef);
			
			// Lower Arm
			//Left
			bodyDef.position.Set(startX - (20 / Config.WORLD_SCALE), startY - ( 40 / Config.WORLD_SCALE));
			var lowerLeftArm:b2Body = Play.world.CreateBody(bodyDef);
			lowerLeftArm.CreateFixture(fixtureDef);
			//Right
			bodyDef.position.Set(startX + (20 / Config.WORLD_SCALE), startY - ( 40 / Config.WORLD_SCALE));
			var lowerRightArm:b2Body = Play.world.CreateBody(bodyDef);
			lowerRightArm.CreateFixture(fixtureDef);
			
			// Hand
			// Common Hand
			box = new b2PolygonShape();
			box.SetAsBox(handWidth / Config.WORLD_SCALE , handWidth / Config.WORLD_SCALE);
			fixtureDef.shape = box;
			//Left 
			bodyDef.position.Set(startX - (20 / Config.WORLD_SCALE), startY - ( 80 / Config.WORLD_SCALE));
			var leftHand:b2Body = Play.world.CreateBody(bodyDef);
			leftHand.CreateFixture(fixtureDef);
			//Right
			bodyDef.position.Set(startX + (20 / Config.WORLD_SCALE), startY - ( 80 / Config.WORLD_SCALE));
			var rightHand:b2Body = Play.world.CreateBody(bodyDef);
			rightHand.CreateFixture(fixtureDef);
			
			// Common Leg
			box = new b2PolygonShape();
			box.SetAsBox(legWidth / Config.WORLD_SCALE , legHeight / Config.WORLD_SCALE);
			fixtureDef.shape = box;
			
			// Upper Leg
			//Left
			bodyDef.position.Set(startX - (12.5 / Config.WORLD_SCALE), startY + (150 / Config.WORLD_SCALE));
			var upperLeftLeg:b2Body = Play.world.CreateBody(bodyDef);
			upperLeftLeg.CreateFixture(fixtureDef);
			//Right
			bodyDef.position.Set(startX + (12.5 / Config.WORLD_SCALE), startY + (150 / Config.WORLD_SCALE));
			var upperRightLeg:b2Body = Play.world.CreateBody(bodyDef);
			upperRightLeg.CreateFixture(fixtureDef);
			
			// Lower Leg
			//Left
			bodyDef.position.Set(startX - (12.5 / Config.WORLD_SCALE), startY + (200 / Config.WORLD_SCALE));
			var lowerLeftLeg:b2Body = Play.world.CreateBody(bodyDef);
			lowerLeftLeg.CreateFixture(fixtureDef);
			//Right
			bodyDef.position.Set(startX + (12.5 / Config.WORLD_SCALE), startY + (200 / Config.WORLD_SCALE));
			var lowerRightLeg:b2Body = Play.world.CreateBody(bodyDef);
			lowerRightLeg.CreateFixture(fixtureDef);
			
			// Feet
			// Common Feet
			box = new b2PolygonShape();
			box.SetAsBox(feetWidth / Config.WORLD_SCALE , feetHeight / Config.WORLD_SCALE);
			fixtureDef.shape = box;
			//Left
			bodyDef.position.Set(startX - (20 / Config.WORLD_SCALE), startY + (235 / Config.WORLD_SCALE));
			var leftFoot:b2Body = Play.world.CreateBody(bodyDef);
			leftFoot.CreateFixture(fixtureDef);
			//Right
			bodyDef.position.Set(startX + (20 / Config.WORLD_SCALE), startY + (235 / Config.WORLD_SCALE));
			var rightFoot:b2Body = Play.world.CreateBody(bodyDef);
			rightFoot.CreateFixture(fixtureDef);
			
			
			/* ------------------------ Joints --------------------------- */
			
			// common
			jointDef.enableLimit = true;
			
			// Head to torso1 
			jointDef.lowerAngle = -40 / (180 / Math.PI);
			jointDef.upperAngle = 40 / (180 / Math.PI);
			jointDef.Initialize(head, torso1, new b2Vec2(startX, startY + (20 / Config.WORLD_SCALE)))
			Play.world.CreateJoint(jointDef);
			
			//Torso1 to torso2
			jointDef.lowerAngle = -15 / (180 / Math.PI);
			jointDef.upperAngle = 15 / (180 / Math.PI);
			jointDef.Initialize(torso1, torso2, new b2Vec2(startX, startY + (80 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Torso2 to torso3
			jointDef.lowerAngle = -15 / (180 / Math.PI);
			jointDef.upperAngle = 15 / (180 / Math.PI);
			jointDef.Initialize(torso2, torso3, new b2Vec2(startX, startY + (110 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Upper Left Arm to Torso1
			jointDef.lowerAngle = -180 / (180 / Math.PI);
			jointDef.upperAngle = 60 / (180 / Math.PI);
			jointDef.Initialize(torso1, upperLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY + (30 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Upper Right Arm to Torso1
			jointDef.lowerAngle = -60 / (180 / Math.PI);
			jointDef.upperAngle = 180 / (180 / Math.PI);
			jointDef.Initialize(torso1, upperRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY + (30 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			
			//Lower Left Arm to Torso1
			jointDef.lowerAngle = -1 / (180 / Math.PI);
			jointDef.upperAngle = 180 / (180 / Math.PI);
			jointDef.Initialize(upperLeftArm, lowerLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY - (20 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Lower Right Arm to Torso1
			jointDef.lowerAngle = -180 / (180 / Math.PI);
			jointDef.upperAngle = 1 / (180 / Math.PI);
			jointDef.Initialize(upperRightArm, lowerRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY - (20 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Left hand to Lower Left Arm
			jointDef.lowerAngle = -40 / (180 / Math.PI);
			jointDef.upperAngle = 40 / (180 / Math.PI);
			jointDef.Initialize(leftHand, lowerLeftArm, new b2Vec2(startX - (20 / Config.WORLD_SCALE), startY - (70 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Right hand to Lower Right Arm
			jointDef.lowerAngle = -40 / (180 / Math.PI);
			jointDef.upperAngle = 40 / (180 / Math.PI);
			jointDef.Initialize(rightHand, lowerRightArm, new b2Vec2(startX + (20 / Config.WORLD_SCALE), startY - (70 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Left upper leg to torso3
			jointDef.lowerAngle = -1/ (180 / Math.PI);
			jointDef.upperAngle = 60 / (180 / Math.PI);
			jointDef.Initialize(torso3, upperLeftLeg, new b2Vec2(startX - (10 / Config.WORLD_SCALE), startY + (120 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Right upper leg to torso3
			jointDef.lowerAngle = -1/ (180 / Math.PI);
			jointDef.upperAngle = 60 / (180 / Math.PI);
			jointDef.Initialize(upperRightLeg, torso3, new b2Vec2(startX + ( 10 / Config.WORLD_SCALE), startY + ( 120 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Lower left leg to upper left leg
			jointDef.lowerAngle = -60/ (180 / Math.PI);
			jointDef.upperAngle = 60 / (180 / Math.PI);
			jointDef.Initialize(lowerLeftLeg, upperLeftLeg, new b2Vec2(startX - (10 / Config.WORLD_SCALE), startY + (170 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Lower right leg to upper right leg
			jointDef.lowerAngle = -60/ (180 / Math.PI);
			jointDef.upperAngle = 60 / (180 / Math.PI);
			jointDef.Initialize(lowerRightLeg, upperRightLeg, new b2Vec2(startX + (10 / Config.WORLD_SCALE), startY + (170 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Left foot to lower left leg
			jointDef.lowerAngle = -1/ (180 / Math.PI);
			jointDef.upperAngle = 1 / (180 / Math.PI);
			jointDef.Initialize(leftFoot, lowerLeftLeg, new b2Vec2(startX - (15 / Config.WORLD_SCALE), startY + (235 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			//Right foot to lower left leg
			jointDef.lowerAngle = -1/ (180 / Math.PI);
			jointDef.upperAngle = 1 / (180 / Math.PI);
			jointDef.Initialize(rightFoot, lowerRightLeg, new b2Vec2(startX + (15 / Config.WORLD_SCALE), startY + (235 / Config.WORLD_SCALE)));
			Play.world.CreateJoint(jointDef);
			
			/* 
			leftFoot.SetType(b2Body.b2_staticBody);
			rightHand.SetType(b2Body.b2_staticBody);
			*/
			
		}
	}
}