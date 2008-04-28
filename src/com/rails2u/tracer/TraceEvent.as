package com.rails2u.tracer {
    import flash.events.Event;
    import flash.geom.Point;

    public class TraceEvent extends Event {
        public static const TRACE:String = 'trace';

        public function TraceEvent(type:String, 
           times:uint, 
           repeatCount:uint,
           point:Point,
           bublles:Boolean = false, cancelable:Boolean = false
        ) {
            super(type, bubbles, cancelable);
            _times = times;
            _repeatCount = repeatCount;
            _point = point;
        }

        public var stash:Object;

        private var _point:Point;
        public function get point():Point {
            return _point;
        }

        private var _times:uint;
        public function get times():uint {
            return _times;
        }

        private var _repeatCount:uint;
        public function get repeatCount():uint {
            return _repeatCount;
        }
    }
}
