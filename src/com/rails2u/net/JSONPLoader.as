package com.rails2u.net {
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;
    import flash.events.Event;
    import flash.errors.IllegalOperationError;
    import flash.events.TimerEvent;
    import flash.events.IOErrorEvent;
    import flash.utils.Timer;
    import flash.system.Security;

    /**
     * How to use:
     *   // JSONPLoader.allowCurrentDomain(); // Allow show browsing url's domain.
     *   var loader:JSONPLoader = new JSONPLoader();
     *   loader.addEventListener(Event.COMPLETE, function(e:Event):void {
     *       log(e.target.data);
     *   });
     *   loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
     *       log('error!');
     *   });
     *   // loader.callbackQueryName = 'callback'; // Default name is "callback"
     *   loader.load('http://del.icio.us/feeds/json/url/data?hash=46efc577b7ddef30d1c6fd13311b371e');
     */
    public class JSONPLoader extends EventDispatcher {
        public var encoding:String = 'UTF-8';
        public var callbackQueryName:String = 'callback';
        public var data:Object;
        public var timeout:Number = 30;
        protected var nowCallbackFuncName:String;

        public static var callbackObjects:Object = {};
        public static var inited:Boolean = false;

        public function JSONPLoader(url:String = undefined):void {
            if (!ExternalInterface.available) throw (new IllegalOperationError('ExternalInterface.available should be true.'));
            if (!inited) init();
            if (url) load(url);
        }

        public static function allowCurrentDomain():void {
            var domain:String = execExternalInterface('return location.host.split(":", 2)[0]');
            Security.allowDomain(domain);
        }

        protected static function init():void {
            inited = true;
            ExternalInterface.addCallback('jsonpCallbacks', jsonpCallbacks);

        }

        public function load(url:String):void {
            if (observeTimer) {
                jsRemoveCallback(nowCallbackFuncName);
                clearObserveTimer();
            }
            var callbackFuncName:String = '_' + (new Date()).getTime().toString();
            nowCallbackFuncName = callbackFuncName;
            jsAddCallback(callbackFuncName);

            var loadURL:String = url + ((url.indexOf('?') > 0) ?  '&' : '?') + 
                    encodeURIComponent(callbackQueryName) + '=' + encodeURIComponent('as3callbacks.' + callbackFuncName);
            callbackObjects[callbackFuncName] = this;
            observeTimeout(timeout, callbackFuncName);
            createScriptElement(loadURL);
        }

        protected function createScriptElement(loadURL:String):void {
            var js:Array = [];
            js.push("var script = document.createElement('script');");
            js.push("script.charset = '" + encoding + "';");
            js.push("script.src = '" + loadURL + "';");
            js.push("setTimeout(function(){document.body.appendChild(script);}, 10);");
            dispatchEvent(new Event(Event.OPEN));
            execExternalInterface(js.join("\n"));
        }

        protected static function jsonpCallbacks(callbackFuncName:String, obj:Object):void {
            var target:JSONPLoader = callbackObjects[callbackFuncName] as JSONPLoader;
            if (target) {
                target.data = obj;
                target.dispatchEvent(new Event(Event.COMPLETE));
                target.clearObserveTimer();
            } else {
                new Error("Don't found callback(" + callbackFuncName + ").");
            }
        }

        protected static function execExternalInterface(cmd:String):* {
            cmd = "(function() {" + cmd + ";})";
            return ExternalInterface.call(cmd);
        }

        protected function jsAddCallback(callbackFuncName:String):void {
            var js:String = 'if (!window.as3callbacks) window.as3callbacks = {};window.as3callbacks["' + callbackFuncName + 
                '"] = function(obj) { document.getElementsByName("' + 
                ExternalInterface.objectID + '")[0].jsonpCallbacks("' + callbackFuncName + '",obj) };';
            execExternalInterface(js);
        }

        protected function jsRemoveCallback(callbackFuncName:String):void {
            var js:String = 'if (window.as3callbacks) window.as3callbacks["' + callbackFuncName + '"] = function() {};';
            execExternalInterface(js);
        }

        protected var observeTimer:Timer;
        protected function observeTimeout(sec:Number, callbackFuncName:String):void
        {
            observeTimer = new Timer(sec * 1000, 1);
            observeTimer.addEventListener(TimerEvent.TIMER, timeoutErrorHandlerBind(callbackFuncName), false, 1, true);
            observeTimer.start();
        }

        protected function timeoutErrorHandlerBind(callbackFuncName:String):Function {
            return function(e:TimerEvent):void {
                jsRemoveCallback(callbackFuncName);
                timeoutErrorHandler(e);
            }
        }

        protected function timeoutErrorHandler(e:TimerEvent):void 
        {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, 'Request timeout'));
            clearObserveTimer();
        }

        // FIXME: Public namespace should be protected.
        public function clearObserveTimer():void {
            observeTimer.removeEventListener(TimerEvent.TIMER, timeoutErrorHandler);
            observeTimer.stop();
            observeTimer = null;
        }
    }
}
