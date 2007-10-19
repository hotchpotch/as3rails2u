package com.rails2u.debug {
    import flash.errors.IllegalOperationError;
    import flash.external.ExternalInterface;
    import flash.utils.ByteArray;
    import flash.utils.getQualifiedClassName;

    public class ExportJS {
        private static var inited:Boolean = false;
        public static var objects:Object = {};

        public static function init():void {
            if (!ExternalInterface.available) throw (new IllegalOperationError('ExternalInterface.available should be true.'));
            if (inited) return;

            ExternalInterface.addCallback('updateProperty', updateProperty);
            ExternalInterface.addCallback('callMethod', callMethod);
            inited = true;
        }
            
        public static function updateProperty(target:Object, chainProperties:Array, value:Object):void {
            var obj:Object = objects[target];
            while (chainProperties.length > 1) {
                var prop:String = chainProperties.shift();
                obj = obj[prop];
            }
            obj[chainProperties.shift()] = value;
        }

        public static function callMethod(target:Object, chainProperties:Array, args:Object):void {
            var obj:Object = objects[target];
            while (chainProperties.length > 1) {
                var prop:String = chainProperties.shift();
                obj = obj[prop];
            }
            var func:Function = obj[chainProperties.shift()] as Function;
            if (func is Function) func.apply(obj, args);
        }
        
        private static var cNum:uint = 0;
        private static function nonameCounter():uint {
            return cNum++;
        }

        public static function export(targetObject:*, jsName:String = undefined):String {
            init();

            if (!jsName) jsName = '_' + nonameCounter();

            var b:ByteArray = new ByteArray();
            b.writeObject(targetObject);
            b.position = 0;
            var obj:Object = b.readObject();

            // custom for Sprite/Shape
            if (!obj.hasOwnProperty('graphics') && targetObject.hasOwnProperty('graphics'))
                obj.graphics = {};

            objects[jsName] = targetObject;
            ExternalInterface.call(<><![CDATA[ 
                (function(target, objectID, jsName, klassName) {
                    var defineAttr = function(obj, parentProperties) {
                        var tmp = {};
                        for (var i in obj) {
                            if (obj[i] && (typeof(obj[i]) == "object" || typeof(obj[i]) == "array")) {
                                var pp = parentProperties.slice();
                                pp.push(i);
                                defineAttr(obj[i], pp);
                                continue;
                            }
                            tmp[i] = obj[i];
                            obj.__defineGetter__(i, 
                                (function(attrName) {
                                    return function() { 
                                       return this.__tmpProperties__[attrName]
                                    }
                                })(i)
                            );
                            obj.__defineSetter__(i, 
                                (function(attrName) {
                                    return function(val) { 
                                        document.getElementsByName(objectID)[0].updateProperty(jsName, [].concat(parentProperties).concat(attrName), val);
                                        return this.__tmpProperties__[attrName] = val;
                                    }
                                })(i)
                            );
                        }
                        obj.__noSuchMethod__ = function(attrName, args) {
                            document.getElementsByName(objectID)[0].callMethod(jsName, [].concat(parentProperties).concat(attrName), args);
                        }
                        obj.__tmpProperties__ = tmp;
                    }
                    defineAttr(target, []);
                    target.toString = function() { return klassName };
                    window[jsName] = target;
                ;})
            ]]></>.toString(), obj, ExternalInterface.objectID, jsName, getQualifiedClassName(targetObject));
            return jsName;
        }
    }
}
