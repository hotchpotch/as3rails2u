package com.rails2u.bridge {
    import flash.utils.Proxy;
    import flash.external.ExternalInterface;
    import flash.utils.flash_proxy;

    public dynamic class JSProxy extends Proxy {
        use namespace flash_proxy;

        public static var proxyLogger:Function = function(...args):void {};
        private var _stack:Array;
        private var _nextCallIsstack:Boolean = false;

        public function JSProxy(stack:Array = null) {
            _stack = stack || [];
        }

        public function get proxy():JSProxy {
            return getProperty('proxy');
        }

        public static function get proxy():JSProxy {
             return new JSProxy();
        }

        flash_proxy override function callProperty(name:*, ...args):* {
            var $name:* = $check(name);
            if ($name) {
                return callJS(newStack($name, args));
            } else {
                return new JSProxy(newStack(name, args));
            }
        }

        flash_proxy function $check(name:*):* {
            if (name.toString().indexOf('$') == 0 && name.toString().length >= 2) {
                var r:String = name.toString().replace(/^\$+/, '');
                if (name is QName) {
                    return new QName(name.uri, r);
                } else {
                    return r;
                }
            } else {
                return '';
            }
        }

        flash_proxy override function getProperty(name:*):* {
            var $name:* = $check(name);
            if ($name) {
                return callJS(newStack($name));
            } else {
                return new JSProxy(newStack(name));
            }
        }

        flash_proxy override function getDescendants(name:*):* {
            return callJS(newStack(name));
        }

        flash_proxy function newStack(name:*, args:Array = null):Array {
            var stack:Array = _stack.slice();
            if (args != null) {
                stack.push([name, args.slice()]);
            } else {
                stack.push(name);
            }
            return stack;
        }

        flash_proxy override function hasProperty(name:*):Boolean {
            return callJS(newStack(new QName('', name))) !== undefined;
        }

        flash_proxy override function setProperty(name:*, value:*):void {
            callJSSetProperty(newStack(name), value);
        }

        flash_proxy override function deleteProperty(name:*):Boolean {
            return false;
        }

        public function toString():String {
            var res:Array = createCommand(_stack.slice());
            var cmd:String = res[0];
            var args:Array = res[1];
            return '[JSProxy] ' + cmd + ' :: ' + args.join(', ');
        }

        flash_proxy function callJSSetProperty(stack:Array, value:*):* {
            if (!ExternalInterface.available) 
                return null;

            var res:Array = createCommand(stack);
            var cmd:String = res[0];
            var args:Array = res[1];
            args.push(value);
            var argsString:String = createArgsString(args.length);

            cmd = "(function(" + argsString + ") {return " + cmd + " = _" + (args.length - 1).toString() + ";})";
            proxyLogger(cmd);
            return ExternalInterface.call.apply(null, [cmd].concat(args));
        }

        flash_proxy function callJS(stack:Array):* {
            if (!ExternalInterface.available) 
                return null;

            var res:Array = createCommand(stack);
            var cmd:String = res[0];
            var args:Array = res[1];
            var argsString:String = createArgsString(args.length);

            if (args.length > 0) {
                cmd = "(function(" + argsString + ") {return " + cmd + ";})";
                proxyLogger(cmd);
                proxyLogger(args);
                return ExternalInterface.call.apply(null, [cmd].concat(args));
            } else {
                cmd = "(function() {return " + cmd + ";})";
                proxyLogger(cmd);
                return ExternalInterface.call(cmd);
            }
        }

        flash_proxy function createArgsString(len:uint):String {
            var res:Array = [];
            for (var i:uint = 0; i < len; i++) {
                res.push('_' + i);
            }
            return res.join(', ');
        }

        flash_proxy function createCommand(stack:Array):Array {
            var receivers:Array = [];
            var args:Array = [];
            var argsStrings:Array = [];
            while (stack.length) {
                var o:* = stack.shift();
                if (o is Array) {
                    o = o as Array;
                    var cmd:String = nameToString(o[0]) + '(';
                    var cmdArgs:Array = [];
                    var a:Array = o[1].slice();
                    while (a.length) {
                        cmdArgs.push('_' + args.length);
                        args.push(a.shift());
                    }
                    cmd += cmdArgs.join(', ');
                    cmd += ')';
                    receivers.push(cmd);
                } else {
                    receivers.push(nameToString(o));
                }
            }
            return [receivers.join('.').replace(/\.\[/g, '['), args];
        }

        flash_proxy function nameToString(name:*):String {
            if (name is QName) {
                return name.localName.toString();
            } else {
                return '[' + name.toString() + ']';
            }
        }
    }
}
