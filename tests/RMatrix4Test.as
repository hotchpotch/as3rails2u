package {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import com.rails2u.geom.*;

    [SWF(frameRate=60, background=0x000000)]
    public class RMatrix4Test extends Sprite {
        public function RMatrix4Test() {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            rmatrix4();
        }

        public function rmatrix4():void {
            var m:RMatrix4;
            var t:SimpleTest = new SimpleTest('RMatrix4Test');
            t.run(function():void {
                t.notEquals(m1create(), m2create());
                t.equals(m1create(), m1create());
                t.equals(m2create(), m2create());

                t.equals(m1create().add(m2create()), new RMatrix4([
                    3,0,6,8,
                    3,8,2,15,
                    12,18,7,21
                ]));
                t.equals(m2create().add(m1create()), new RMatrix4([
                    3,0,6,8,
                    3,8,2,15,
                    12,18,7,21
                ]));
                t.equals(m1create().subtract(m2create()), new RMatrix4([
                   -1,4,0,0,
                   7,4,12,1,
                   6,2,15,3 
                ]));

                t.equals(m1create().scalerMultiply(10), new RMatrix4([
                    10,20,30,40,
                    50,60,70,80,
                    90,100,110,120
                ]));

                t.equals(m1create().multiply(m2create()), new RMatrix4([
                    7, 26, -19, 49, 
                    19, 58, -43, 133, 
                    31, 90, -67, 217
                ]));
                t.equals(m2create().multiply(m1create()), new RMatrix4([
                    19, 22, 25, 32, 
                    -37, -42, -47, -45, 
                    7, 14, 21, 37
                ]));

                m = m1create();
                var m2:RMatrix4 = m2create();
                m.concat(m2);
                t.equals(m, new RMatrix4([
                    7, 26, -19, 49, 
                    19, 58, -43, 133, 
                    31, 90, -67, 217
                ]));
                t.equals(m2, m2create());

                t.opEquals(0, m1create().det);
                t.opEquals(44, m2create().det);

                t.equals(m2create().inverse(), new RMatrix4([
                    8/11, 4/11, 1/11, -69/11, 
                    -23/44, -17/44, 1/11, 3.9772727272727275, 
                    -1/2, -1/2, 0, 11/2
                ]));
            });
        }

        public function m1create():RMatrix4 {
            return new RMatrix4([
                1,2,3,4,
                5,6,7,8,
                9,10,11,12
            ]);
        }

        public function m2create():RMatrix4 {
            return new RMatrix4([
                2,-2,3,4,
                -2,2,-5,7,
                3,8,-4,9
            ]);
        }
    }
}
