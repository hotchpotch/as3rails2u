package com.rails2u.geom {
    public class RVertex3 extends RVector3 {
        public function RVertex3(x:Number = 0, y:Number = 0, z:Number = 0) {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public override function toString():String {
            return 'RVertex3[x:' + x + ', y:' + y + ', z:' + z + ']';
        }

        public function toVector3():RVector3 {
            return new RVector3(x, y, z);
        }
    }
}
