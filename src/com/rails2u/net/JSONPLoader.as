package com.rails2u.net {
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;
    import flash.events.Event;
    import flash.errors.IllegalOperationError;

    public class JSONPLoader extends EventDispatcher {
        public static var callbackObjects:Object = {};

        public var url:String;
        public var encoding:String = 'UTF-8';
        public var callbackQueryName:String = 'callback';
        public var data:Object;

        public static var inited:Boolean = false;

        public function JSONPLoader(url:String = ''):void {
            if (!ExternalInterface.available) throw (new IllegalOperationError('ExternalInterface.available should be true.'));

            if (!inited) init();
            this.url = url;
        }

        private function init():void {
            inited = true;
            ExternalInterface.addCallback('jsonpCallbacks', jsonpCallbacks);

        }

        private function jsFuncRegister(callbackFuncName:String):void {
            var js:String = 'if (!window.as3callbacks) window.as3callbacks = {};window.as3callbacks["' + callbackFuncName + 
                '"] = function(obj) { document.getElementById("' + 
                ExternalInterface.objectID + '").jsonpCallbacks("' + callbackFuncName + '",obj) };';
            log(js);
            execExternalInterface(js);
        }

        public function load():void {
            var callbackFuncName:String = '_' + (new Date()).getTime().toString();
            log(callbackFuncName);
            jsFuncRegister(callbackFuncName);

            var loadURL:String = url + ((url.indexOf('?') > 0) ?  '&' : '?') + 
                    encodeURIComponent(callbackQueryName) + '=' + encodeURIComponent('as3callbacks.' + callbackFuncName);
            callbackObjects[callbackFuncName] = this;
            createScriptElement(loadURL);
        }

        private function createScriptElement(loadURL:String):void {
            var js:Array = [];
            js.push("var script = document.createElement('script');");
            js.push("script.charset = '" + encoding + "';");
            js.push("script.src = '" + loadURL + "';");
            js.push("setTimeout(function(){document.body.appendChild(script);}, 10);");
            execExternalInterface(js.join("\n"));
        }

        private static function jsonpCallbacks(callbackFuncName:String, obj:Object):void {
            var target:JSONPLoader = callbackObjects[callbackFuncName] as JSONPLoader;
            if (target) {
                target.data = obj;
                target.dispatchEvent(new Event(Event.COMPLETE));
            }
        }

        private static function execExternalInterface(cmd:String):* {
            cmd = "(function() {" + cmd + ";})";
            return ExternalInterface.call(cmd);
        }
    }
}
