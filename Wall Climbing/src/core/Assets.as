package core {
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	/* 
	GRIPS: https://www.vecteezy.com/vector-art/121239-climbing-wall-grip
	*/

	public class Assets {
		[Embed(source = "../../Resources/Font/font.png")]
		private static var PermanentMarkerBitMap:Class;
		[Embed(source="../../Resources/Font/font.fnt", mimeType="application/octet-stream")]
		private static var PermanentMarkerXML:Class;
		
		[Embed(source="../../Resources/rock.jpg")]
		private static const ROCK:Class;
		public static var ROCK_TEXTURE:Texture;
		
		[Embed(source = "../../Resources/Grips/Blue.png")]
		private static const BLUE_GRIP:Class;	
		[Embed(source = "../../Resources/Grips/Green.png")]
		private static const GREEN_GRIP:Class;	
		[Embed(source = "../../Resources/Grips/Orange.png")]
		private static const ORANGE_GRIP:Class;	
		[Embed(source = "../../Resources/Grips/Pink.png")]
		private static const PINK_GRIP:Class;	
		[Embed(source = "../../Resources/Grips/Purple.png")]
		private static const PURPLE_GRIP:Class;	
		[Embed(source = "../../Resources/Grips/Red.png")]
		private static const RED_GRIP:Class;	
		[Embed(source = "../../Resources/Grips/Turkos.png")]
		private static const TURKOS_GRIP:Class;	
		[Embed(source="../../Resources/Grips/Yellow.png")]
		private static const YELLOW_GRIP:Class;	
		
		
		
		
		
		[Embed(source="../../Resources/Character/hair.png")]
		private static const HAIR:Class;
		public static var HAIR_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/lowerLeg.png")]
		private static const LOWER_LEG:Class;
		public static var LOWER_LEG_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/upperLeg.png")]
		private static const UPPER_LEG:Class;
		public static var UPPER_LEG_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/lowerArm.png")]
		private static const LOWER_ARM:Class;
		public static var LOWER_ARM_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/upperArm.png")]
		private static const UPPER_ARM:Class;
		public static var UPPER_ARM_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/hand.png")]
		private static const HAND:Class;
		public static var HAND_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/foot.png")]
		private static const FOOT:Class;
		public static var FOOT_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/ribs1.png")]
		private static const RIBS_1:Class;
		public static var RIBS_1_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/ribs2.png")]
		private static const RIBS_2:Class;
		public static var RIBS_2_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/ribs3.png")]
		private static const RIBS_3:Class;
		public static var RIBS_3_TEXTURE:Texture;
		
		public static var gripTextures:Vector.<Texture> = new Vector.<Texture>;
		
		public static function init():void {
			var fontTexture:Texture = Texture.fromEmbeddedAsset(PermanentMarkerBitMap);
			var bitMapFont:BitmapFont = new BitmapFont(fontTexture, XML(new PermanentMarkerXML));
			TextField.registerBitmapFont(bitMapFont, "PermanentMarker");
			
			loadGripPNG(BLUE_GRIP);
			loadGripPNG(GREEN_GRIP);
			loadGripPNG(ORANGE_GRIP);
			loadGripPNG(PINK_GRIP);
			loadGripPNG(PURPLE_GRIP);
			loadGripPNG(RED_GRIP);
			loadGripPNG(TURKOS_GRIP);
			loadGripPNG(YELLOW_GRIP);
			
			ROCK_TEXTURE = Texture.fromBitmap(new ROCK());
			
			HAIR_TEXTURE = Texture.fromBitmap(new HAIR());
			RIBS_1_TEXTURE = Texture.fromBitmap(new RIBS_1());
			RIBS_2_TEXTURE = Texture.fromBitmap(new RIBS_2());
			RIBS_3_TEXTURE = Texture.fromBitmap(new RIBS_3());
			UPPER_ARM_TEXTURE = Texture.fromBitmap(new UPPER_ARM());
			LOWER_ARM_TEXTURE = Texture.fromBitmap(new LOWER_ARM());
			UPPER_LEG_TEXTURE = Texture.fromBitmap(new UPPER_LEG());
			LOWER_LEG_TEXTURE = Texture.fromBitmap(new LOWER_LEG());
			HAND_TEXTURE = Texture.fromBitmap(new HAND());
			FOOT_TEXTURE = Texture.fromBitmap(new FOOT());
			
		}
		
		private static function loadGripPNG(png:Class):void {
			var texture:Texture = Texture.fromBitmap(new png());
			gripTextures.push(texture);
		}
		
	}
}