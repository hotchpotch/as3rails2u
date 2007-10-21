package com.rails2u.bridge {
    import flash.errors.IllegalOperationError;
    import flash.external.ExternalInterface;
    import flash.utils.ByteArray;
    import flash.utils.getQualifiedClassName;
    import flash.utils.Dictionary;
    import flash.utils.describeType;

    public class ExportJS {
        private static var inited:Boolean = false;
        private static var readOnlyObjectCache:Object;
        public static var objects:Object;
        public static var dict:Dictionary;

        public static function reloadObject(jsName:String):void {
            export(objects[jsName], jsName);
            ExternalInterface.call('console.info', 'reloaded: ' + jsName);
        }

        public static function getASObject(jsName:String):* {
            return objects[jsName];
        }
        
        public static function getJSName(targetObject:*):* {
            return dict[targetObject];
        }
        
        private static var cNum:uint = 0;
        private static function anonCounter():uint {
            return cNum++;
        }

        public static function export(targetObject:*, jsName:String = undefined):String {
            init();

            if (dict[targetObject])
                jsName = dict[targetObject];

            if (!jsName) jsName = '__as3__.' + anonCounter();

            var b:ByteArray = new ByteArray();
            b.writeObject(targetObject);
            b.position = 0;
            var obj:Object = b.readObject();

            //var readOnlyObject:Object = getReadOnlyObject(targetObject);

            // custom for Sprite/Shape
            if (!obj.hasOwnProperty('graphics') && targetObject.hasOwnProperty('graphics'))
                obj.graphics = {};

            objects[jsName] = targetObject;
            dict[targetObject] = jsName;
            ExternalInterface.call(<><![CDATA[ 
                (function(target, objectID, jsName, klassName) {
                    try {
                        var swfObject = document.getElementsByName(objectID)[0];

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
                                            if (swfObject.updateProperty(jsName, [].concat(parentProperties).concat(attrName), val)) {
                                                return this.__tmpProperties__[attrName] = val;
                                            } else {
                                                return this.__tmpProperties__[attrName];
                                            }
                                        }
                                    })(i)
                                );
                            }
                            obj.__noSuchMethod__ = function(attrName, args) {
                                swfObject.callMethod(jsName, [].concat(parentProperties).concat(attrName), args);
                            }
                            obj.__tmpProperties__ = tmp;
                        }
                        defineAttr(target, []);

                        target.__reload = function() { return swfObject.reloadObject(jsName) };
                        if (!target.hasOwnProperty('reload')) target.reload = target.__reload;

                        target.toString = function() { return klassName };
                        var chainProperties = jsName.split('.');
                        var windowTarget = window;
                        while (chainProperties.length > 1) {
                            var prop = chainProperties.shift();
                            if (typeof windowTarget[prop] == 'undefined')
                                windowTarget[prop] = {};
                            windowTarget = windowTarget[prop];
                        }
                        windowTarget[chainProperties.shift()] = target;
                    } catch(e) {
                        console.error(e.message, jsName);
                    }
                ;})
            ]]></>.toString(), 
              obj, 
              ExternalInterface.objectID, 
              jsName, 
              getQualifiedClassName(targetObject)
            );
            return jsName;
        }

        private static function init():void {
            if (!ExternalInterface.available) throw (new IllegalOperationError('ExternalInterface.available should be true.'));
            if (inited) return;

            objects = {};
            dict = new Dictionary();
            readOnlyObjectCache = {};
            ExternalInterface.addCallback('updateProperty', updateProperty);
            ExternalInterface.addCallback('callMethod', callMethod);
            ExternalInterface.addCallback('reloadObject', reloadObject);
            inited = true;
        }
            
        private static function updateProperty(jsName:String, chainProperties:Array, value:Object):Boolean {
            var obj:Object = objects[jsName];
            while (chainProperties.length > 1) {
                var prop:String = chainProperties.shift();
                obj = obj[prop];
            }
            try {
                obj[chainProperties.shift()] = value;
            } catch(e:Error) { 
                ExternalInterface.call('console.error', e.message);
                return false;
            }
            return true;
        }

        private static function callMethod(jsName:String, chainProperties:Array, args:Object):* {
            var obj:Object = objects[jsName];
            var klassName:String = getQualifiedClassName(obj);
            var tmp:Array = chainProperties.slice();
            var prop:String;
            while (chainProperties.length > 1) {
                prop = chainProperties.shift();
                obj = obj[prop];
            }
            prop = chainProperties.shift();
            if(!obj.hasOwnProperty(prop)) {
                ExternalInterface.call('console.error', jsName + '(' + [klassName].concat(tmp).join('.') + ') is undefined.');
                return;
            }
            var func:Function = obj[prop] as Function;

            try {
                if (func is Function) {
                    return func.apply(obj, args);
                } else {
                    ExternalInterface.call('console.error', jsName + '(' + [klassName].concat(tmp).join('.') + ') is not function.');
                }
            } catch(e:Error) { 
                ExternalInterface.call('console.error', e.message);
            }
        }

        /*
        private static var readOnlyObjectRegexp:RegExp = new RegExp('name="([^"]+?)" .*access="readonly" .*type="([^"]+?)"');
        private static function getReadOnlyObject(target:*):Object {
            var klassName:String = getQualifiedClassName(target);
            if (!readOnlyObjectCache[klassName]) {
                // don't use E4X.
                readOnlyObjectCache[klassName] = {};
                var xmlLines:Array = describeType(target).toString().split("\n");
                for each(var line:String in xmlLines) {
                    line.replace(readOnlyObjectRegexp, function(_trash, name, _type, ...trashes):void {
                         readOnlyObjectCache[klassName][name] = _type;
                    });
                }
            }
            return readOnlyObjectCache[klassName];
        }
        */
    }
}
