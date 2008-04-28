package com.rails2u.geom {
    import com.rails2u.utils.ObjectUtil;
    import flash.geom.Matrix;

    public class RMatrix4 {
        public var a00:Number = 1, a01:Number = 0, a02:Number = 0, a03:Number = 0;
        public var a10:Number = 0, a11:Number = 1, a12:Number = 0, a13:Number = 0;
        public var a20:Number = 0, a21:Number = 0, a22:Number = 1, a23:Number = 0;

        public function RMatrix4(args:Array = null) {
            if (args && args.length == 12) {
                a00 = args[0]; a01 = args[1]; a02 = args[2]; a03 = args[3];
                a10 = args[4]; a11 = args[5]; a12 = args[6]; a13 = args[7];
                a20 = args[8]; a21 = args[9]; a22 = args[10]; a23 = args[11];
            }
        }

        public function identity():RMatrix4 {
            a01, a02, a03, a10, a12, a13, a20, a21, a23 = 0
            a00, a11, a22 = 1;
            return this;
        }

        public static function identity():RMatrix4 {
            return new RMatrix4();
        }

        public static function translation(tx:Number = 0, ty:Number = 0, tz:Number = 0):RMatrix4 {
            return new RMatrix4([
                    1, 0, 0, tx,
                    0, 1, 0, ty,
                    0, 0, 1, tz
                    ]);
        }

        public function clone():RMatrix4 {
            return new RMatrix4([
                    a00, a01, a02, a03,
                    a10, a11, a12, a13,
                    a20, a21, a22, a23
            ]);
        }

        public function equals(m:RMatrix4):Boolean {
            return a00 == m.a00 &&
                   a01 == m.a01 &&
                   a02 == m.a02 &&
                   a03 == m.a03 &&
                   a10 == m.a10 &&
                   a11 == m.a11 &&
                   a12 == m.a12 &&
                   a13 == m.a13 &&
                   a20 == m.a20 &&
                   a21 == m.a21 &&
                   a22 == m.a22 &&
                   a23 == m.a23;
        }

        public function add(m:RMatrix4):RMatrix4 {
            return new RMatrix4([
                a00 + m.a00, a01 + m.a01, a02 + m.a02, a03 + m.a03, 
                a10 + m.a10, a11 + m.a11, a12 + m.a12, a13 + m.a13, 
                a20 + m.a20, a21 + m.a21, a22 + m.a22, a23 + m.a23
            ]);
        }

        public function subtract(m:RMatrix4):RMatrix4 {
            return new RMatrix4([
                a00 - m.a00, a01 - m.a01, a02 - m.a02, a03 - m.a03, 
                a10 - m.a10, a11 - m.a11, a12 - m.a12, a13 - m.a13, 
                a20 - m.a20, a21 - m.a21, a22 - m.a22, a23 - m.a23
            ]);
        }

        public function scalerMultiply(scale:Number):RMatrix4 {
            return new RMatrix4([
                a00 * scale,a01 * scale,a02 * scale,a03 * scale,
                a10 * scale,a11 * scale,a12 * scale,a13 * scale,
                a20 * scale,a21 * scale,a22 * scale,a23 * scale
            ]);
        }

        /*
        public function scalerVector3(v:RVector3):RMatrix4 {
            var m:RMatrix4 = new RMatrix4();
            m.a00 = v.x;
            m.a11 = v.y;
            m.a22 = v.z;
            return clone().multiply(m);
        }
        */

        public function multiply(m:RMatrix4):RMatrix4 {
            return new RMatrix4([
                this.a00 * m.a00 + this.a01 * m.a10 + this.a02 * m.a20,
                this.a00 * m.a01 + this.a01 * m.a11 + this.a02 * m.a21,
                this.a00 * m.a02 + this.a01 * m.a12 + this.a02 * m.a22,
                this.a00 * m.a03 + this.a01 * m.a13 + this.a02 * m.a23 + this.a03,

                this.a10 * m.a00 + this.a11 * m.a10 + this.a12 * m.a20,
                this.a10 * m.a01 + this.a11 * m.a11 + this.a12 * m.a21,
                this.a10 * m.a02 + this.a11 * m.a12 + this.a12 * m.a22,
                this.a10 * m.a03 + this.a11 * m.a13 + this.a12 * m.a23 + this.a13,

                this.a20 * m.a00 + this.a21 * m.a10 + this.a22 * m.a20,
                this.a20 * m.a01 + this.a21 * m.a11 + this.a22 * m.a21,
                this.a20 * m.a02 + this.a21 * m.a12 + this.a22 * m.a22,
                this.a20 * m.a03 + this.a21 * m.a13 + this.a22 * m.a23 + this.a23
            ]);
        }

        public function multiply3x3(m:RMatrix4):RMatrix4 {
            return new RMatrix4([
                this.a00 * m.a00 + this.a01 * m.a10 + this.a02 * m.a20,
                this.a00 * m.a01 + this.a01 * m.a11 + this.a02 * m.a21,
                this.a00 * m.a02 + this.a01 * m.a12 + this.a02 * m.a22,
                this.a03,

                this.a10 * m.a00 + this.a11 * m.a10 + this.a12 * m.a20,
                this.a10 * m.a01 + this.a11 * m.a11 + this.a12 * m.a21,
                this.a10 * m.a02 + this.a11 * m.a12 + this.a12 * m.a22,
                this.a13,

                this.a20 * m.a00 + this.a21 * m.a10 + this.a22 * m.a20,
                this.a20 * m.a01 + this.a21 * m.a11 + this.a22 * m.a21,
                this.a20 * m.a02 + this.a21 * m.a12 + this.a22 * m.a22,
                this.a23,
            ]);
        }

        /*
         * return @self
         */
        public function copy3x3(m:RMatrix4):RMatrix4 {
            a00 = m.a00; a01 = m.a01; a02 = m.a02;
            a10 = m.a10; a11 = m.a11; a12 = m.a12;
            a20 = m.a20; a21 = m.a21; a22 = m.a22;
            return this;
        }

        public function copy(m:RMatrix4):RMatrix4 {
            a00 = m.a00; a01 = m.a01; a02 = m.a02; a03 = m.a03;
            a10 = m.a10; a11 = m.a11; a12 = m.a12; a13 = m.a13;
            a20 = m.a20; a21 = m.a21; a22 = m.a22; a23 = m.a23;
            return this;
        }

        public function clear():RMatrix4 {
            a00 = 1; a01 = 0; a02 = 0; a03 = 0;
            a10 = 0; a11 = 1; a12 = 0; a13 = 0;
            a20 = 0; a21 = 0; a22 = 1; a23 = 0;
            return this;
        }

        public function multiplyVector3(v:RVector3):RMatrix4 {
            return multiply(v.matrix());
        }

        public function concatVector3(v:RVector3):RMatrix4 {
            return concat(v.matrix());
        }

        public function toArray():Array {
            return [
                a00, a01,a02, a03,
                a10, a11,a12, a13,
                a20, a21,a22, a23
            ];
        }

        public function concat(m:RMatrix4):RMatrix4 {
            var _a00:Number = this.a00 * m.a00 + this.a01 * m.a10 + this.a02 * m.a20;
            var _a01:Number = this.a00 * m.a01 + this.a01 * m.a11 + this.a02 * m.a21;
            var _a02:Number = this.a00 * m.a02 + this.a01 * m.a12 + this.a02 * m.a22;
            var _a03:Number = this.a00 * m.a03 + this.a01 * m.a13 + this.a02 * m.a23 + this.a03;

            var _a10:Number = this.a10 * m.a00 + this.a11 * m.a10 + this.a12 * m.a20;
            var _a11:Number = this.a10 * m.a01 + this.a11 * m.a11 + this.a12 * m.a21;
            var _a12:Number = this.a10 * m.a02 + this.a11 * m.a12 + this.a12 * m.a22;
            var _a13:Number = this.a10 * m.a03 + this.a11 * m.a13 + this.a12 * m.a23 + this.a13;

            var _a20:Number = this.a20 * m.a00 + this.a21 * m.a10 + this.a22 * m.a20;
            var _a21:Number = this.a20 * m.a01 + this.a21 * m.a11 + this.a22 * m.a21;
            var _a22:Number = this.a20 * m.a02 + this.a21 * m.a12 + this.a22 * m.a22;
            var _a23:Number = this.a20 * m.a03 + this.a21 * m.a13 + this.a22 * m.a23 + this.a23;

            a00 = _a00, a01 = _a01, a02 = _a02, a03 = _a03; 
            a10 = _a10, a11 = _a11, a12 = _a12, a13 = _a13; 
            a20 = _a20, a21 = _a21, a22 = _a22, a23 = _a23; 
            return this;
        }

        public function get det():Number {
            return (a00 * a11 - a10 * a01) * a22 
                 - (a00 * a21 - a20 * a01) * a12 
                 + (a10 * a21 - a20 * a11) * a02;
        }

        public function inverse():RMatrix4 {
            if (Math.abs(det) <= 1.0e-64) {
                return new RMatrix4([0,0,0,0, 0,0,0,0, 0,0,0,0]);
            } else {
                var invDet:Number = 1/det;

                return new RMatrix4([
                    invDet *  (a11 * a22 - a21 * a12),
                    invDet * -(a01 * a22 - a21 * a02),
                    invDet *  (a01 * a12 - a11 * a02),
                    invDet * -(a01 * (a12 * a23 - a22 * a13) - a11 * (a02 * a23 - a22 * a03) + a21 * (a02 * a13 - a12 * a03)),

                    invDet * -(a10 * a22 - a20 * a12),
                    invDet *  (a00 * a22 - a20 * a02),
                    invDet * -(a00 * a12 - a10 * a02),
                    invDet *  (a00 * (a12 * a23 - a22 * a13) - a10 * (a02 * a23 - a22 * a03) + a20 * (a02 * a13 - a12 * a03)),

                    invDet *  (a10 * a21 - a20 * a11),
                    invDet * -(a00 * a21 - a20 * a01),
                    invDet *  (a00 * a11 - a10 * a01),
                    invDet * -(a00 * (a11 * a23 - a21 * a13) - a10 * (a01 * a23 - a21 * a03) + a20 * (a01 * a13 - a11 * a03)),
                ]);
            }
        }

        public function get tx():Number {
            return a03;
        }
        public function get ty():Number {
            return a13;
        }
        public function get tz():Number {
            return a23;
        }
        public function set tx(v:Number):void {
             a03 = v;
        }
        public function set ty(v:Number):void {
             a13 = v;
        }
        public function set tz(v:Number):void {
             a23 = v;
        }

        public function vector():RVector3 {
            //return transformVector3(new RVector3(tx, ty, tz));
            return transformVector3(new RVector3(tx, ty, tz));

            //var m:RMatrix4 = new RMatrix4();
            //m.tx = tx;
            //m.ty = ty;
            //m.tz = tz;
            //var m2:RMatrix4 = multiply(m);
            //return new RVector3(m2.tx, m2.ty, m2.tz);
        }

        public function transformVector3(v:RVector3):RVector3 {
            v = v.clone();
            var vx:Number = v.x + tx;
            var vy:Number = v.y + ty;
            var vz:Number = v.z + tz;
            v.x = vx * a00 + vy * a01 + vz * a02 ;
            v.y = vx * a10 + vy * a11 + vz * a12 ;
            v.z = vx * a20 + vy * a21 + vz * a22 ;
            return v;

            //return new RVector3(
            //    v.x * a00 + v.y * a01 + v.z * a02 + a03,
            //    v.x * a10 + v.y * a11 + v.z * a12 + a13,
            //    v.x * a20 + v.y * a21 + v.z * a22 + a23
            //);
        }

        public function transformXYZ(x:Number, y:Number, z:Number):Array {
            var vx:Number = x + tx;
            var vy:Number = y + ty;
            var vz:Number = z + tz;
            x = vx * a00 + vy * a01 + vz * a02 + a03;
            y = vx * a10 + vy * a11 + vz * a12 + a13;
            z = vx * a20 + vy * a21 + vz * a22 + a23;
            return [x, y, z];
        }

        public function transformXY(x:Number, y:Number, vz:Number):Array {
            var vx:Number = x + tx;
            var vy:Number = y + ty;
            x = vx * a00 + vy * a01 + vz * a02 + a03;
            y = vx * a10 + vy * a11 + vz * a12 + a13;
            return [x, y];
        }

        public function rotateX(rad:Number):RMatrix4 {
            return concat(rotationX(rad));
        }

        public function rotateY(rad:Number):RMatrix4 {
            return concat(rotationY(rad));
        }

        public function rotateZ(rad:Number):RMatrix4 {
            return concat(rotationZ(rad));
        }

        public function scaleX(factor:Number):RMatrix4 {
            return concat(RMatrix4.scaleX(factor));
        }

        public function scaleY(factor:Number):RMatrix4 {
            return concat(RMatrix4.scaleY(factor));
        }

        public function scaleZ(factor:Number):RMatrix4 {
            return concat(RMatrix4.scaleZ(factor));
        }

        public function scale(fx:Number, fy:Number = NaN, fz:Number = NaN):RMatrix4 {
            if (isNaN(fy)) fy = fz = fx;

            return scaleX(fx).scaleY(fy).scaleZ(fz);
        }

        public function toString():String {
            return "RMatrix4: [\n" + 
            "[" + [a00,a01,a02,a03].join(", ") + "]\n" +
            "[" + [a10,a11,a12,a13].join(", ") + "]\n" +
            "[" + [a02,a21,a22,a23].join(", ") + "]]";
        }

        public function flMatrix():Matrix {
            //return new Matrix(values[0][0], values[0][1], values[1][0],
            //                  values[1][1], values[3][0], values[3][1]); 
            //return new Matrix(a00, a01, tx,
            //                  a10, a11, ty);
            return new Matrix(a00, a01, a10,
                              a11, 0, 0);
        }

        public static function scaleX(factor:Number):RMatrix4 {
            var m:RMatrix4 = identity();
            m.a00 = factor;
            return m;
        }

        public static function scaleY(factor:Number):RMatrix4 {
            var m:RMatrix4 = identity();
            m.a11 = factor;
            return m;
        }

        public static function scaleZ(factor:Number):RMatrix4 {
            var m:RMatrix4 = identity();
            m.a22 = factor;
            return m;
        }

        public static function rotationX(rad:Number):RMatrix4 {
            var cos:Number = Math.cos(rad);
            var sin:Number = Math.sin(rad);
            return new RMatrix4([
                1 , 0   , 0    , 0 , 
                0 , cos , -sin , 0 , 
                0 , sin , cos  , 0 , 
            ]);
        }

        public static function rotationY(rad:Number):RMatrix4 {
            var cos:Number = Math.cos(rad);
            var sin:Number = Math.sin(rad);
            return new RMatrix4([
                cos  , 0 , sin , 0 , 
                0    , 1 , 0   , 0 , 
                -sin , 0 , cos , 0 , 
            ]);
        }

        public static function rotationZ(rad:Number):RMatrix4 {
            var cos:Number = Math.cos(rad);
            var sin:Number = Math.sin(rad);
            return new RMatrix4([
                cos , -sin , 0 , 0 , 
                sin , cos  , 0 , 0 , 
                0   , 0    , 1 , 0 , 
            ]);
        }

        public static function eulerRotation(a:Number, b:Number, c:Number):RMatrix4 {
            var ca:Number = Math.cos(a);
            var sa:Number = Math.sin(a);
            var cb:Number = Math.cos(b);
            var sb:Number = Math.sin(b);
            var cc:Number = Math.cos(c);
            var sc:Number = Math.sin(c);
            return new RMatrix4([ 
                cb*cc   , sa*sb*cc  + ca*sc , -ca*sb*cc + sa*sc , 0 , 
                - cb*sc , -sa*sb*sc + ca*cc , ca*sb*sc  + sa*cc , 0 , 
                sb      , -sa*cb            , ca*cb             , 0
            ]);

        }
    }
}
