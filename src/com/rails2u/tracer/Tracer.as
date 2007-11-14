package com.rails2u.tracer {
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    import flash.geom.Point;

    public class Tracer extends EventDispatcher {
        private var _repeat:uint = 1;
        public function get repeat():uint {
            return _repeat;
        }
        public function set repeat(__repeat:uint):void {
            _repeat = __repeat;
        }
        
        private var _distance:uint = 10;
        public function get distance():uint {
            return _distance;
        }
        public function set distance(__distance:uint):void {
            _distance = __distance;
        }

        private var _started:Boolean = false;
        public function get started():Boolean {
            return _started;
        }
        public function set started(__started:Boolean):void {
            _started = __started;
        }
        
        private var _repeatCount:uint = 0;
        public function get repeatCount():uint {
            return _repeatCount;
        }
        public function set repeatCount(__repeatCount:uint):void {
            _repeatCount = __repeatCount;
        }
        
        protected var times:uint = 0;
        public function start():void {
            started = true;
            while (repeat == 0 || repeatCount < repeat) {
                run();
                repeatCount++;
            }
            started = false;
        }

        protected function run():void {
            times = 0;
            while(started && times < distance) {
                times++;
                dispatchEvent(getTraceEvent());
            }
        }

        protected function getTraceEvent():TraceEvent {
            return new TraceEvent(TraceEvent.TRACE,times,repeatCount, getPoint() );
        }

        protected function getPoint():Point{
            return matrix.transformPoint(new Point());
        }

        private var _matrix:Matrix = new Matrix;
        public function get matrix():Matrix {
            return _matrix;
        }
        
        public function set matrix(__matrix:Matrix):void {
            _matrix = __matrix;
        }
        

        /*
         * ToDo
         * - wait (delay)
         * - matrix
         * - next (iterator)
         *
         */
    }
}
