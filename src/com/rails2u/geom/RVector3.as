package com.rails2u.geom {
    import flash.geom.Point;
    public class RVector3 {
        public static const ZERO:RVector3 = new RVector3(0, 0, 0);

        public var x:Number = 0;
        public var y:Number = 0;
        public var z:Number = 0;

        public var stash:Object;

        public function RVector3(x:Number = 0, y:Number = 0, z:Number = 0) {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public function clone():RVector3 {
            return new RVector3(x, y, z);
        }

        public function add(v:RVector3):RVector3 {
            return new RVector3(x + v.x, y + v.y, z + v.z);
        }

        public function subtract(v:RVector3):RVector3 {
            return new RVector3(x - v.x, y - v.y, z - v.z);
        }

        public function inverse():RVector3 {
            return new RVector3(x * -1, y * -1, z * -1);
        }

        public function multiply(n:Number):RVector3 {
            return new RVector3(x * n, y * n, z * n);
        }

        public function get length():Number {
            return Math.sqrt(x*x + y*y + z*z);
        }

        public function equals(v:RVector3):Boolean {
            return (x == v.x) && (y == v.y) && (z == v.z);
        }

        public function normalize(len:Number = 1):RVector3 {
            var l:Number = length / len;
            return l == 0 ? ZERO.clone() : new RVector3(x / l, y / l, z / l);
        }

        public function dot(v:RVector3):Number {
            return x * v.x + y * v.y + z * v.z;
        }

        public function cross(v:RVector3):RVector3 {
            return new RVector3(y*v.z - z*v.y, z*v.x - x*v.z, x*v.y - y*v.x);
        }

        public function distance(v:RVector3):Number {
            return subtract(v).length;
        }

        public function degree(v:RVector3):Number {
            /*
            var n0:RVector3 = normalize();
            var n1:RVector3 = v.normalize();
            // (n1.y < n0.y && n1.x > n0.x) || 
            if (n1.y > n0.y && n1.x < n0.x) {
                return -1 * Math.acos(dot(v) / (length * v.length));
            } else {
                return Math.acos(dot(v) / (length * v.length));
            }
            */
            return Math.acos(dot(v) / (length * v.length));
        }

        public function angle(v:RVector3):Number {
            return degree(v) * 180/Math.PI;
        }

        // not test..
        public function matrix4():RMatrix4 {
            var m:RMatrix4 = new RMatrix4();
            m.tx = x;
            m.ty = y;
            m.tz = z;
            return m;
        }

        public function toString():String {
            return 'RVector3[x:' + x + ', y:' + y + ', z:' + z + ']';
        }
    }
}
