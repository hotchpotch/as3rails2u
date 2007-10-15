package com.rails2u.debug {
    import flash.utils.Dictionary;
    import flash.events.Event;
    import flash.utils.getTimer;

    /**
    * Simple Benchmark class
    * 
  * example:
  * <listing version="3.0">
  * Benchmark.start('check');
  * // code
  * Benchmark.end('check');
  * </listing>
  * 
  * <listing version="3.0">
  * Benchmark.benchmark('check2', function() {
  *   // code
  * }, this);
  * </listing>
    */
    public class Benchmark {
        private static var dict:Object = {};

        public static function start(name:String):void {
            dict[name] = getTimer();
        }

        public static function benchmark(name:String, callback:Function, bindObject:Object = null):Number {
            start(name);
            callback.call(bindObject);
            return end(name);
        }

        public static function loop(name:String, callback:Function, bindObject:Object = null, times:uint = 100):Number {
            start(name);
            for (var i:uint = 0; i < times; i++) 
                callback.call(bindObject);
            return end(name);
        }

        public static function end(name:String):Number {
            var re:uint = getTimer() - dict[name];
            log(name + ':' + ' ' + re + 'ms');
            return re;
        }
    }
}
