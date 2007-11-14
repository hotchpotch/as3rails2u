package com.rails2u.tracer {
    import flash.geom.Point;
    public class CircleTracer extends CenterTracer {
        
        private var _radius:Number;
        public function get radius():Number {
            return _radius;
        }
        
        public function CircleTracer(radius:Number) {
            super();
            this._radius = radius;
        }

        protected override function getPoint():Point {
            // slow: ToDo
            var p:Point = new Point(
                Math.cos(360 / distance * (times - 1) * Math.PI / 180) * _radius,
                Math.sin(360 / distance * (times - 1) * Math.PI / 180) * _radius
            );
            return matrix.transformPoint(p);
        }
    }
}
