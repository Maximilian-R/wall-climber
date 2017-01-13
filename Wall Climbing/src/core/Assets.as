package core {
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
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
		
		public static var gripTextures:Vector.<Texture>;
		
		
		
		[Embed(source = "../../Resources/atlas.png")]
		private static var Atlas:Class;
		public static var TEXTURE_ATLAS:TextureAtlas;
		
		[Embed(source="../../Resources/atlas.xml", mimeType="application/octet-stream")]
		private static var AtlasXML:Class;
		
		public static function init():void {
			var fontTexture:Texture = Texture.fromEmbeddedAsset(PermanentMarkerBitMap);
			var bitMapFont:BitmapFont = new BitmapFont(fontTexture, XML(new PermanentMarkerXML));
			TextField.registerBitmapFont(bitMapFont, "PermanentMarker");
			
			ROCK_TEXTURE = Texture.fromBitmap(new ROCK());
			
			TEXTURE_ATLAS = new TextureAtlas(Texture.fromBitmap(new Atlas()), XML(new AtlasXML)); 
			gripTextures = TEXTURE_ATLAS.getTextures("Grip");
		}
	}
}