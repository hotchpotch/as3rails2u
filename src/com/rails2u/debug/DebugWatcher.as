package com.rails2u.debug {
    import flash.events.EventDispatcher;
    import com.rails2u.utils.Reflection;
    import flash.events.Event;
    import mx.logging.Log;
    public class DebugWatcher {
        public static function monitorEvents(target:EventDispatcher, ... arg):void {
            if ( arg.length > 0 ) {
                for each(var evName:String in arg) {
                    target.addEventListener(evName, eventLog);
                }
            } else {
                var targetRefrection:Reflection = Reflection.factory(target);
                var eventlist:Array = targetRefrection.getAllDispatchEvents();
                for each(var ary:Object in eventlist) {
                    if(ary.name != Event.ENTER_FRAME) target.addEventListener(ary.name, eventLog);
                }
            }
        }

        public static function unmonitorEvents(target:EventDispatcher, ... arg):void {
            if ( arg.length > 0 ) {
                for each(var evName:String in arg) {
                    target.removeEventListener(evName, eventLog);
                }
            } else {
                var targetRefrection:Reflection = Reflection.factory(target);
                var eventlist:Array = targetRefrection.getAllDispatchEvents();
                for each(var ary:Object in eventlist) {
                    if(ary.name != Event.ENTER_FRAME) target.removeEventListener(ary.name, eventLog);
                }
            }
        }

        protected static function eventLog(e:Event):void {
            log(e);
        }
    }
}
