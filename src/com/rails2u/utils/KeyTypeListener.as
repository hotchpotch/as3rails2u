package com.rails2u.utils
{
    import flash.events.KeyboardEvent;
    import flash.utils.describeType;
    import flash.ui.Keyboard;
    import flash.display.InteractiveObject;
    import flash.utils.Dictionary;
    
    use namespace key_down;
    use namespace key_up;
    
    /**
    * KeyTypeListener attach keytype events(KEY_DOWN, KEY_UP) utility.
    * 
    * How to use:
    *   please see examples dir.
    */
    
    public class KeyTypeListener
    {
        private static var objects:Dictionary = new Dictionary;
        
        public static function attach(
            obj:InteractiveObject, 
            currentTarget:Object = null,
            useCapture:Boolean = false, priority:int = 0, 
            useWeakReference:Boolean = false
        ):KeyTypeListener
        {
            var instance:KeyTypeListener = new KeyTypeListener(obj, currentTarget, useCapture, priority, useWeakReference);
            instance.bindKey(KeyboardEvent.KEY_DOWN);
            instance.bindKey(KeyboardEvent.KEY_UP);
            objects[obj] = instance;
            return instance;
        }
        
        public static function detach(obj:InteractiveObject):Boolean {
            if(objects[obj]) {
                objects[obj].destroyImpl();
                delete objects[obj];
                return true;
            } else {
                return false;
            }
        }
        
        protected var obj:InteractiveObject;
        protected var currentTarget:Object;
        public var ignoreTargets:Array = [];
        
        private var _forceStop:Boolean = true;
        public function get forceStop():Boolean {
            return _forceStop;
        }
        public function set forceStop(forceStop:Boolean):void {
            this._forceStop = forceStop;
        }
        
        private var reflection:Reflection;
        private var callableCache:Object = {};
        private var useCapture:Boolean;
        private var priority:int;
        private var useWeakReference:Boolean;
         
        public function KeyTypeListener(obj:InteractiveObject, currentTarget:Object = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            this.obj = obj;
            this.useCapture = useCapture;
            this.priority = priority;
            this.useWeakReference = useWeakReference;
            
            if (currentTarget == null) {
                this.currentTarget = obj;
            } else {
                this.currentTarget = currentTarget;
            }
            reflection = Reflection.factory(this.currentTarget);
        }
        
        public function bindKey(type:String):void {
            obj.addEventListener(type, KeyboardEvent.KEY_DOWN == type ? keyDownHandler : keyUpHandler, useCapture, priority, useWeakReference);
        }
        
        public function destroy():void {
            KeyTypeListener.detach(obj);
        }
        
        internal function destroyImpl():void {
           obj.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, useCapture);
           obj.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler, useCapture);
        }
        
        // みじかくできる
        protected function keyDownHandler(e:KeyboardEvent):void {
            keyHandlerDelegeter(e, key_down);
        }
        
        protected function keyUpHandler(e:KeyboardEvent):void {
            keyHandlerDelegeter(e, key_up);
        }

        protected function isIgnore(o:*):Boolean {
            if (ignoreTargets.length) {
                for each(var klass:Class in ignoreTargets) {
                    if (o is klass) return true;
                }
            }
            return false;
        }
        
        protected function keyHandlerDelegeter(e:KeyboardEvent, ns:Namespace):void {
            if (isIgnore(e.target)) return;

            if (!(e.target == this.currentTarget || e.target == this.obj)) {
                if (e.target.stage && this.obj == e.target.stage) {
                    // ...
                } else {
                    return;
                }
            }
            // log(String.fromCharCode(e.charCode));
            
            var methodName:String = getMethodName(e);
            // log(methodName, ns);
            methodCall(e, 'before', ns);
            methodCall(e, methodName, ns);
            methodCall(e, 'after', ns);
        }
        
        private function methodCall(e:KeyboardEvent, methodName:String, ns:Namespace):void {
            var argsNum:int = reflection.methodArgs(methodName, ns);
            if(argsNum >= 0) {
                switch(argsNum) {
                    case 0:
                        currentTarget.ns::[methodName].call(currentTarget);
                        break;
                    case 1:
                        currentTarget.ns::[methodName].call(currentTarget, e);
                        break;
                    default:
                        throw new Error(methodName + ' arguments should be 0 or 1');
                        break;
                }
            } else if(methodName == 'after') {
                // default after call stopPropagation because always looping event...
                if (forceStop) e.stopPropagation();
            }
        }
        
        private const RE_NUM_CHAR:RegExp = /^\d$/;
        public function getMethodName(e:KeyboardEvent):String {
            if (keyboardConstfromCharCode(e.keyCode)) {
                return keyboardConstfromCharCode(e.keyCode);
            }
            var char:String = String.fromCharCode(e.keyCode);
            
            if (!e.shiftKey) char = char.toLowerCase();
            if (e.ctrlKey) char = 'CTRL_' + char;
            if (RE_NUM_CHAR.test(char)) char = '_' + char;
            return char;
        }
        
        public static function keyboardConstfromCharCode(code:uint):String {
            return Reflection.factory(Keyboard).constantsTable[code];
        }
    }
}
