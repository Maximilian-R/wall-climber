package physics {
	import core.Config;
	import flash.display.Stage;
	import flash.display.Sprite;
	import starling.core.Starling;
	import Box2D.Dynamics.b2DebugDraw;

	public class Debugger extends b2DebugDraw {
		
		private var _ns:Stage = Starling.current.nativeStage;
		private var _debug_sprite:Sprite = new Sprite();
		private var _lineThickness:Number = 2.0;
		private var _fillAlpha:Number = 0.5;
		
		public function Debugger() {
			setup();
		}
		
		private function setup():void {
			_ns.addChild(_debug_sprite);
			
			SetSprite(_debug_sprite);
			SetDrawScale(Config.WORLD_SCALE);
			SetFlags(b2DebugDraw.e_shapeBit);
			AppendFlags(b2DebugDraw.e_jointBit);
			SetFillAlpha(_fillAlpha);
			SetLineThickness(_lineThickness);
		}
		
		public function setDebugSpritePosition(y:Number):void {
			_debug_sprite.y = y;
		}
		
		public function destroy():void {
			_ns.removeChild(_debug_sprite);
		}
	}
}