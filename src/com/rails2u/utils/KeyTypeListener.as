package rails2u.utils
{
    import flash.events.KeyboardEvent;
    import flash.utils.describeType;
    import flash.ui.Keyboard;
    import flash.display.InteractiveObject;
    
        use namespace key_down;
        // namespace key_up;
    public class KeyTypeListener
    {
        public static function attach(
            obj:InteractiveObject, 
            currentTarget:Object = null,
	        useCapture:Boolean = false, priority:int = 0, 
	        useWeakReference:Boolean = false
        ):KeyTypeListener
        {
            var instance:KeyTypeListener = new KeyTypeListener(obj, currentTarget);
            instance.bindKeyDown(useCapture, priority, useWeakReference);
            // obj.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, useCapture, priority, useWeakReference);
            return instance;
        }
        
        protected var obj:InteractiveObject;
        protected var currentTarget:Object;
        private var reflection:XML;
        private var callableCache:Object;
        private var isDynamic:Boolean = false;
         
        public function KeyTypeListener(obj:InteractiveObject, currentTarget:Object = null):void {
            this.obj = obj;
            if (currentTarget == null) {
	            this.currentTarget = obj;
            } else {
	            this.currentTarget = currentTarget;
            }
            reflection = describeType(this.currentTarget);
            
            if (reflection.type.isDynamic == 'true') {
                isDynamic = true;
            } else {
                callableCache = {};
            }
        }
        
        public function bindKeyDown(useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            obj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, useCapture, priority, useWeakReference);
        }
        
        private function keyDownHandler(e:KeyboardEvent):void {
            // log(e.currentTarget, e.target, this.currentTarget, this.obj);
            if (!(e.target == this.currentTarget || e.target == this.obj)) {
                return;
            }
            
            var methodName:String = getMethodName(e);
            if (isCallable('before', key_down)) {
                currentTarget.key_down::['before'].call(currentTarget, e);
            }
            
            if (isCallable(methodName, key_down)) {
                currentTarget.key_down::[methodName].call(currentTarget, e);
            }
            
            if (isCallable('after', key_down)) {
                currentTarget.key_down::['after'].call(currentTarget, e);
            } else {
                // default after call stopPropagation because always looping event...
                e.stopPropagation();
            }
        }
        
        private function isCallable(methodName:String, ns:Namespace):Boolean {
            if (isDynamic)
                return reflection.method.(
	              String(attribute('uri')) == ns.uri && @name == methodName
	            ).length() > 0;
	            
            if (callableCache[methodName] == null) {
	            if (reflection.method.(
	              String(attribute('uri')) == ns.uri && @name == methodName
	            ).length() > 0) {
	                callableCache[methodName] = true;
	            } else {
	                callableCache[methodName] = false;
	            }
            }
            return callableCache[methodName];
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
        
        private static var keyboardRefrection:XML = describeType(Keyboard);
        public static function keyboardConstfromCharCode(code:uint):String {
            return keyboardConstTable[code];
        }
        
        private static var _keyboardConstTable:Object;
        public static function get keyboardConstTable():Object {
            if(!_keyboardConstTable) {
                _keyboardConstTable = {};
	            var keyboardRefrection:XML = describeType(Keyboard);
	            for each(var _const:String in keyboardRefrection.constant.@name) {
	                _keyboardConstTable[Keyboard[_const]] = _const;
	            }
            }
            return _keyboardConstTable;
        }
    }
}