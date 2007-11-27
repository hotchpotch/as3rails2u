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

        public static function callJS(cmd:String):* {
            cmd = "(function() {" + cmd + ";})";
            return ExternalInterface.call(cmd);
        }

        public static function bindCallJS(bindName:String):Function {
            return function(cmd:String):* {
                return callJS(bindName + cmd);
            };
        }
    }
}
