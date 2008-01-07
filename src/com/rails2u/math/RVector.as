package com.rails2u.math {
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

        public function innerProduct(v:RVector):Number {
            return x * v.x + y * v.y;
        }

        public function distance(v:RVector):Number {
            return subtract(v).length;
        }

        public function degree(v:RVector):Number {
            if ((v.y < y && v.x > x) || (v.y > y && v.x < x)) {
                return -1 * Math.acos(innerProduct(v) / (length * v.length));
            } else {
                return Math.acos(innerProduct(v) / (length * v.length));
            }
        }

        public function toString():String {
            return 'RVector[x:' + x + ', y:' + y + ']';
        }
    }
}
