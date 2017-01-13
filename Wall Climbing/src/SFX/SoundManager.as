package SFX {
	import SFX.SimpleSound;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer
	;
	public class SoundManager {
		
		private static var _instance:SoundManager = null;
		
		private var _sounds:Vector.<SimpleSound> = new Vector.<SimpleSound>;
		
		public function SoundManager() {}
		
		public static function sharedInstance():SoundManager {
            if (_instance == null) {
                _instance = new SoundManager();
            }
            return _instance;
        }
		
		public function playFile(path:String, loops:Number):void {
			var sound:SimpleSound = new SimpleSound(path);
			sound.play(0, loops);
			_sounds.push(sound);
		}
		
		public function pauseAllSounds():void {			
			for each (var sound:SimpleSound in _sounds) {
				sound.pause();
			}
		}
		
		public function resumeAllSounds():void {	
			for each (var sound:SimpleSound in _sounds) {
				sound.resume();
			}
		}
		
		public function stopAllSounds():void {
			SoundMixer.stopAll();
		}
		
	}
}