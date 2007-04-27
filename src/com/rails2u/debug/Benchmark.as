package rails2u.debug {
    import flash.utils.Dictionary;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.getTimer;

    public class Benchmark extends EventDispatcher {
        private static var dict:Object = {};

        public static function start(name:String):void {
            dict[name] = getTimer();
        }

        public static function benchmark(name:String, callback:Function, bindObject:Object = null):Number {
            start(name);
            callback.apply(bindObject);
            return end(name);
        }

        public static function end(name:String):Number {
            var re:uint = getTimer() - dict[name];
            log(name + ':' + ' ' + re + 'ms');
            return re;
        }
    }
}
