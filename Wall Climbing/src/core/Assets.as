package core {
	import starling.textures.Texture;
	/* 
	GRIPS: https://www.vecteezy.com/vector-art/121239-climbing-wall-grip
	*/

	public class Assets {
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
		
		[Embed(source="../../Resources/Character/hår.png")]
		private static const HAIR:Class;
		public static var HAIR_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/ben.png")]
		private static const LEG:Class;
		public static var LEG_TEXTURE:Texture;
		
		[Embed(source="../../Resources/Character/hand.png")]
		private static const HAND:Class;
		public static var HAND_TEXTURE:Texture;
		
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
			loadGripPNG(BLUE_GRIP);
			loadGripPNG(GREEN_GRIP);
			loadGripPNG(ORANGE_GRIP);
			loadGripPNG(PINK_GRIP);
			loadGripPNG(PURPLE_GRIP);
			loadGripPNG(RED_GRIP);
			loadGripPNG(TURKOS_GRIP);
			loadGripPNG(YELLOW_GRIP);
			
			HAIR_TEXTURE = Texture.fromBitmap(new HAIR());
			LEG_TEXTURE = Texture.fromBitmap(new LEG());
			HAND_TEXTURE = Texture.fromBitmap(new HAND());
			RIBS_1_TEXTURE = Texture.fromBitmap(new RIBS_1());
			RIBS_2_TEXTURE = Texture.fromBitmap(new RIBS_2());
			RIBS_3_TEXTURE = Texture.fromBitmap(new RIBS_3());
			
			ROCK_TEXTURE = Texture.fromBitmap(new ROCK());
		}
		
		private static function loadGripPNG(png:Class):void {
			var texture:Texture = Texture.fromBitmap(new png());
			gripTextures.push(texture);
		}
		
	}
}