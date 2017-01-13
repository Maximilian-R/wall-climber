package core {
	import XML
	import XMLList;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	
	public class Config {
		public function Config() {}
		
		// Box2D is tuned for meters, kilograms, and seconds. Thats why using a scale to convert between b2World and sprite on stage.
		public static const WORLD_SCALE:Number = 30;
		public static const WORLD_HEIGHT:Number = 600;
		public static const WORLD_WIDTH:Number = 800;
		
		public static const GRABBED_GRIP_EVENT:String = "GRABBED_GRIP_EVENT";
		public static const STRENGHT_PERCENTAGE_CHANGED:String = "STRENGHT_PERCENTAGE_CHANGED";
		public static const CHANGE_STATE_EVENT:String = " CHANGE_STATE_EVENT";
		
		public static var DISPATCHER:EventDispatcher = new EventDispatcher();
		
		private static var _cache:Object = {};
		private static var _data:XML;
			
		public static function loadConfig():void {
			var loader:URLLoader = new URLLoader();
			var url:URLRequest = new URLRequest("settings.xml");
			
			loader.addEventListener(Event.COMPLETE, Config.completeHandler, false, 0, true);
            loader.addEventListener(Event.OPEN, Config.openHandler, false, 0, true);
            loader.addEventListener(ProgressEvent.PROGRESS, Config.progressHandler, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, Config.securityErrorHandler, false, 0, true);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, Config.httpStatusHandler, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, Config.ioErrorHandler, false, 0, true);
			
			try {
				loader.load(url);
			} catch (error:Error) {
				trace("Error when loading: " + error);
			}
		}
		
		public static function getSetting(attribute:String, node:String):String {
			var nodeKey:String = node+attribute;
			if (_cache[nodeKey] !== undefined) {
				return _cache[nodeKey];
			}
			var values:XMLList = Config._data[node].attribute(attribute);
			if (values.length() == 0) {
				trace("Warning: no attribute " + attribute + " for tag <" + node + ">");
			}
			if (values.length() > 1) {
				trace("Warning: duplicated setting for " + attribute)
			}
			_cache[nodeKey] = values.toString();
			return _cache[nodeKey];
		}
		
		public static function getString(node:String, attribute:String):String {
			return getSetting(attribute, node);
		}
		
		public static function getInt(node:String, attribute:String):int {
			return parseInt(getSetting(attribute, node));
		}
		
		public static function getNumber(node:String, attribute:String):Number {
			return parseFloat(getSetting(attribute, node));
		}
		
		public static function getBool(node:String, attribute:String):Boolean {
			var s:String = (getSetting(attribute, node));
			return (s == "1" || s == "true");
		}
		
		public static function getColor(node:String, attribute:String):uint {
			return parseInt(getSetting(attribute, node), 16);
		}
		
		private static function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var data:XML = XML(loader.data);
			Config._data = data;
			DISPATCHER.dispatchEvent(event);
        }

        private static function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private static function progressHandler(event:ProgressEvent):void {
			var loadProgress:Number = 0;
			if (event.bytesTotal != 0) {
				loadProgress = event.bytesLoaded / event.bytesTotal;
			}
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal + " percentage loaded: " + loadProgress);
        }

        private static function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

        private static function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private static function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }
	}
}