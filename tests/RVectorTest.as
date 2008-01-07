package {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import com.rails2u.math.*;

    [SWF(frameRate=60, background=0x000000)]
    public class RVectorTest extends Sprite {
        public function RVectorTest (){
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            rvector();
        }

        public function rvector(): void {
            var t:SimpleTest = new SimpleTest('RVector');
            t.run(function():void {
                var v1:RVector = new RVector(3,2);
                var v2:RVector = new RVector(2,-1);
                t.equals(v1.add(v2), new RVector(5,1));
                t.equals(v2.add(v1), new RVector(5,1));

                t.equals(v1.subtract(v2), new RVector(1,3));
                t.equals(v2.subtract(v1), new RVector(-1,-3));

                t.equals(v1.inverse(), new RVector(-3,-2));
                t.equals(v2.inverse(), new RVector(-2,1));

                t.equals(v2.add(v1), v1.subtract(v2.inverse()));

                t.equals(v1.multiply(2), new RVector(6, 4));
                t.equals(v1.multiply(-2), new RVector(-6, -4));
                t.equals(v2.multiply(-2), new RVector(-4, 2));

                t.ok(v1.equals(new RVector(3, 2)));
                t.opEquals(v1.length, Math.sqrt(9 + 4));

                t.opEquals(1, v1.normalize().length);
                t.opEquals(1/3, v2.normalize().length/3); // for round...

                t.equals(RVector.ZERO, (new RVector(0,0)).normalize());
                
                t.equals(v1.innerProduct(v2), 4);
                t.equals(v2.innerProduct(v1), 4);

                t.opEquals(Math.sqrt(2), (new RVector(0,1)).distance(new RVector(1,0)));
                t.opEquals(1, (new RVector(0,0)).distance(new RVector(1,0)));
                t.opEquals(0, (new RVector(0,0)).distance(new RVector(0,0)));

                // degree
                t.opEquals(-Math.PI/2, (new RVector(1,0).degree(new RVector(0,1))));
                t.opEquals(Math.PI/2, (new RVector(1,0).degree(new RVector(0,-1))));
                t.opEquals(Math.PI, (new RVector(1,0).degree(new RVector(-100,0))));
                t.opEquals(0, (new RVector(100,0).degree(new RVector(100,0))));
                t.opEquals(0, (new RVector(100,0).degree(new RVector(101,0))));
                t.opEquals(0, (new RVector(0,10).degree(new RVector(0,100))));
                t.opEquals(-135*Math.PI/180, (new RVector(1,0).degree(new RVector(-1, 1))));
            });
        }

    }
}
