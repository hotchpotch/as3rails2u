package com.rails2u.utils {
    import flash.external.ExternalInterface;

    public class Browser {
        public static const FIREFOX:String = 'firefox';
        public static const MSIE:String = 'msie';
        public static const OPERA:String = 'opera';
        public static const SAFARI:String = 'safari';
        public static const UNKNOWN:String = 'unknown';

        private static var _loaded:Boolean = false;
        private static function init():void {
            if (!_loaded) {
                _loaded = true;
                setUserAgent();
                setBrowser();
            }
        }

        public static function get userAgent():String {
            init();
            return _userAgent;
        }

        public static function get browser():String {
            init();
            return _browser;
        }

        private static var _userAgent:String;
        private static function setUserAgent():void {
            _userAgent = String(ExternalInterface.call('function() {return navigator.userAgent;}'));
        }

        private static var _browser:String = UNKNOWN;
        private static function setBrowser():void {
            var tmp:String = _userAgent.toUpperCase();
            if (tmp.indexOf('FIREFOX') >= 0) {
                _browser = FIREFOX;
            } else if(tmp.indexOf('SAFARI') >= 0) {
                _browser = SAFARI;
            } else if(tmp.indexOf('OPERA') >= 0) {
                _browser = OPERA;
            } else if(tmp.indexOf('MSIE') >= 0) {
                _browser = MSIE
            }
        }
    }
}
