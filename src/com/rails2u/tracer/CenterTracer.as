package com.rails2u.tracer {
    public class CenterTracer extends Tracer {
        private var _radius:Number;
        public function get radius():Number {
            return _radius;
        }
        
        public function CircleTracer(radius:Number) {
            super();
            this._radius = radius;
        }
    }
}
