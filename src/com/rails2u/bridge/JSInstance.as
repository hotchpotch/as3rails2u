package com.rails2u.bridge {
    import flash.utils.Proxy;
    import flash.external.ExternalInterface;
    import flash.utils.flash_proxy;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    import com.rails2u.utils.JSUtil;

    public dynamic class JSInstance extends Proxy { //implements IEventDispatcher {
        use namespace flash_proxy;
        protected static var _instance:JSInstance;
        //protected var eventDict:Dictionary;

        public function JSInstance() {
            if (_instance) throw (new ArgumentError('Please access JSInstance.getInstance()'));
            if (!ExternalInterface.available) throw (new IllegalOperationError('ExternalInterface.available should be true.'));

            //eventDict = new Dictionary();
            _instance = this;
            _init();
        }

        public static function getInstance():JSInstance {
            if (!_instance) 
                new JSInstance();

            return _instance;
        }

        protected function _init():void {
        }

        flash_proxy override function callProperty(name:*, ...args):* {
            return JSUtil.selfCallJS.apply(null, [name].concat(args));
        }

        flash_proxy override function setProperty(name:*, value:*):void {
            if (value is Function) {
                ExternalInterface.addCallback(name, value);
            } else {
                jsproxy['$' + name.toString()] = value;
            }
        }

        public static function get jsproxy():JSProxy {
            return JSProxy.proxy.document.getElementById(ExternalInterface.objectID);
        }

        /* impl IEventDispatcher */
        /*
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            eventDict[type] ||= [];
            if (!_hasListener(type, listener)) {
                eventDict[type].push(listener);
            }
        }

        public function dispatchEvent(event:Event):Boolean {
            if (hasEventListener(event.type)) {
                for each (var listener:* in eventDict[event.type]) {
                    listener = listener as Function;
                    if (listener) {
                        listener.call();
                    }
                }
            }
            return true;
        }

        public function hasEventListener(type:String):Boolean {
            return eventDict[type] && eventDict[type].length;
        }

        private function _hasListener(type:String, _listener:Function):Boolean {
            if (eventDict[type]) {
                for (var listener:* in eventDict[type]) {
                    listener = listener as Function;
                    if (listener == _listener) return true;
                }
            }
            return false;
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            if (hasEventListener(type)) 
                while (eventDict[type].length) eventDict[type].shift();
        }

        public function willTrigger(type:String):Boolean {
            return false;
        }
        */
    }
}
