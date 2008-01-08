package com.rails2u.math {
    import flash.geom.Point;
    public class RVector {
        public static const ZERO:RVector = new RVector(0, 0);

        public var x:Number = 0;
        public var y:Number = 0;

        public function RVector(x:Number = 0, y:Number = 0) {
            this.x = x;
            this.y = y;
        }

        public function clone():RVector {
            return new RVector(x, y);
        }

        public function add(v:RVector):RVector {
            return new RVector(x + v.x, y + v.y);
        }

        public function subtract(v:RVector):RVector {
            return new RVector(x - v.x, y - v.y);
        }

        public function inverse():RVector {
            return new RVector(x * -1, y * -1);
        }

        public function multiply(n:Number):RVector {
            return new RVector(x * n, y * n);
        }

        public function get length():Number {
            return Math.sqrt(x*x + y*y);
        }

        public function equals(v:RVector):Boolean {
            return (x == v.x) && (y == v.y);
        }

        public function normalize(len:Number = 1):RVector {
            var l:Number = length / len;
            return l == 0 ? ZERO.clone() : new RVector(x / l, y / l);
        }

        public function dot(v:RVector):Number {
            return x * v.x + y * v.y;
        }

        public function distance(v:RVector):Number {
            return subtract(v).length;
        }

        public function degree(v:RVector):Number {
            var n0:RVector = normalize();
            var n1:RVector = v.normalize();
            // (n1.y < n0.y && n1.x > n0.x) || 
            if (n1.y > n0.y && n1.x < n0.x) {
                return -1 * Math.acos(dot(v) / (length * v.length));
            } else {
                return Math.acos(dot(v) / (length * v.length));
            }
        }

        public function angle(v:RVector):Number {
            return degree(v) * 180/Math.PI;
        }

        public function toString():String {
            return 'RVector[x:' + x + ', y:' + y + ']';
        }

        public function point():Point {
            return new Point(x, y);
        }

        public static function create(o:*):RVector {
            if (o.hasOwnProperty('x') && o.hasOwnProperty('y')) {
                return new RVector(o.x, o.y);
            } else if (o is Array && o.length == 2) {
                return new RVector(o[0], o[1]);
            } else {
                return null;
            }
        }
    }
}
