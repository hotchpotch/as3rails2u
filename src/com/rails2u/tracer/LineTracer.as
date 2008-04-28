package com.rails2u.tracer {
    import flash.geom.Point;
    public class LineTracer extends Tracer {
        private var _length:Number;
        public function get length():Number {
            return _length;
        }
        
        public function set length(__length:Number):void {
            _length = __length;
        }
        
        public function LineTracer(length:Number) {
            super();
            this._length = length;
        }

        protected override function getPoint():Point {
            var p:Point = new Point(
                length * (times - 1) / tracePoints, 0
            );
            return matrix.transformPoint(p);
        }
    }
}
