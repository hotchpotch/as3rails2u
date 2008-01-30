package com.rails2u.utils {
    import flash.external.ExternalInterface;

    public class JSUtil {
        public static function getObjectID():String {
            return ExternalInterface.objectID;
        }

        public static function selfCallJS(cmd:String):* {
            cmd = "return document.getElementById('" + getObjectID() + "')." + cmd;
            return callJS(cmd);
        }

        public static function callJS(cmd:String, ...args):* {
            if (!ExternalInterface.available) 
                return null;

            if (args.length > 0) {
                cmd = "(function() {" + cmd + ".apply(null, arguments);})";
                return ExternalInterface.call.apply(null, [cmd].concat(args));
            } else {
                cmd = "(function() {" + cmd + ";})";
                return ExternalInterface.call(cmd);
            }
        }

        public static function bindCallJS(bindName:String):Function {
            return function(cmd:String):* {
                return callJS(bindName + cmd);
            };
        }

        public static function buildQueryString(hash:Object):String {
            var res:Array = [];
            for (var key:String in hash) {
                res.push(encodeURIComponent(key) + '=' + encodeURIComponent(hash[key]));
            }
            return res.join('&');
        }

        public static function restoreQueryString(str:String):Object {
            var hash:Object = {};
            var res:Array = str.replace(/^#/, '').split('&');
            for each(var s:String in res) {
                if (s.indexOf('=') > 0 && s.length >= 2) {
                    var keyval:Array = s.split('=', 2);
                    hash[keyval[0]] = keyval[1];
                }
            }
            return hash;
        }
    }
}
