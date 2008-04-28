package com.rails2u.utils {
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    import flash.utils.Dictionary;
    import com.rails2u.utils.Reflection;
    import flash.events.Event;

    public class Reflection {
        private static var xmlCache:Object = {}

        public static function describeType(o:*):XML {
            var className:String;
            className = o as String;

            if (!className) {
                className = getQualifiedClassName(o);
            } else {
                o = getDefinitionByName(o);
            }
            return xmlCache[className] ||= flash.utils.describeType(o);
        }

        /*
         * if retrun -1, method is not call method.
         */
        public static function methodArgs(r:XML, methodName:String, ns:Namespace = null):int {
            var res:XMLList = r.method.(
                 ns ? (String(attribute('uri')) == ns.uri && @name == methodName) : @name == methodName
            );

            if (res.length() > 0) {
                return res.parameter.length();
            } else {
                return -1;
            }
        }

        public static function constantsTable(r:XML):Object {
            var res:Object = {};
            var klass:Object = getDefinitionByName(r.@name);
            for each(var cons:String in r.constant.@name) {
                res[klass[cons]] = cons;
            }
            return res;
        }

        private static var instanceCache:Object = {};
        public static function factory(o:*):Reflection {
            var className:String;
            className = o as String;

            if (!className) {
                className = getQualifiedClassName(o);
            }

            return instanceCache[className] ||= new Reflection(o);
        }

        public var type:XML;
        private var cache:Dictionary = new Dictionary;
        public function Reflection(o:*) {
            type = Reflection.describeType(o);
        }

        public function methodArgs(methodName:String, ns:Namespace = null):int {
            return cache[[methodName, ns]] ||= Reflection.methodArgs(type, methodName, ns);
        }

        public function get constantsTable():Object {
            return cache['constantsTable'] ||= Reflection.constantsTable(type);
        }

        public function getAllDispatchEvents():Array {
            var res:Array = [];
            res = res.concat(getDispatchEvents());
            for each (var klass:String in type.extendsClass.@type) {
                var r:Reflection = Reflection.factory(klass);
                res = res.concat(r.getDispatchEvents());
            }
            //Reflection.factory(target).type.@name)).type.metadata.arg.(@key == 'name').@value
            return res;
        }

        public function getDispatchEvents():Array {
            var l:XMLList = type.metadata.(@name == 'Event');
            var res:Array = [];
            for each(var metadata:XML in l) {
                var name:String = metadata.arg.(@key == 'name').@value;
                var klass:Object = getDefinitionByName(metadata.arg.(@key == 'type').@value);
                res.push({'name':name , 'class':klass});
            }
            for each(metadata in type.factory.metadata.(@name == 'Event')) {
                name = metadata.arg.(@key == 'name').@value;
                klass = getDefinitionByName(metadata.arg.(@key == 'type').@value);
                res.push({'name':name , 'class':klass});
            }
            return res;
        }
    }
}
