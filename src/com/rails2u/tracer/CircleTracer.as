package com.rails2u.tracer {
    import flash.geom.Point;
    public class CircleTracer extends CenterTracer {
        public function CircleTracer(radius:Number) {
            super(radius);
        }

        protected override function getPoint():Point {
            // slow: ToDo
            var p:Point = new Point(
                Math.cos(360 / tracePoints * (times - 1) * Math.PI / 180) * radius,
                Math.sin(360 / tracePoints * (times - 1) * Math.PI / 180) * radius
            );
            return matrix.transformPoint(p);
        }
    }
}
