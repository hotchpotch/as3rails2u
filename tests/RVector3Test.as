package {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import com.rails2u.geom.*;

    [SWF(frameRate=60, background=0x000000)]
    public class RVector3Test extends Sprite {
        public function RVector3Test (){
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            rvector3();
        }

        public function rvector3(): void {
            var t:SimpleTest = new SimpleTest('RVector3');
            t.run(function():void {
                var v1:RVector3 = new RVector3(3,2,4);
                var v2:RVector3 = new RVector3(2,-1,-5);

                t.equals(v1.add(v2), new RVector3(5,1,-1));
                t.equals(v2.add(v1), new RVector3(5,1,-1));

                t.equals(v1.subtract(v2), new RVector3(1,3,9));
                t.equals(v2.subtract(v1), new RVector3(-1,-3,-9));

                t.equals(v1.inverse(), new RVector3(-3,-2,-4));
                t.equals(v2.inverse(), new RVector3(-2,1,5));

                t.equals(v2.add(v1), v1.subtract(v2.inverse()));

                t.equals(v1.multiply(2), new RVector3(6, 4, 8));
                t.equals(v1.multiply(-2), new RVector3(-6, -4,-8));
                t.equals(v2.multiply(-2), new RVector3(-4, 2,10));

                t.ok(v1.equals(new RVector3(3, 2, 4)));
                t.opEquals(v1.length, Math.sqrt(9 + 4 + 16));

                t.opEquals(1, v1.normalize().length);
                t.opEquals(1/3, v2.normalize().length/3); // for round...
                t.opEquals(3, v1.normalize(3).length);

                t.equals(RVector3.ZERO, (new RVector3(0,0,0)).normalize());
                
                t.equals(v1.dot(v2), -16);
                t.equals(v2.dot(v1), -16);

                var angle:Number = (new RVector3(5,2,-3)).angle(new RVector3(8, 1, -4));
                t.ok(angle > 13 && angle < 14);
                angle = (new RVector3(-1,4,2)).angle(new RVector3(3,0,5));
                t.ok(angle > 74 && angle < 75);

                //t.opEquals(Math.sqrt(2), (new RVector3(0,1)).distance(new RVector(1,0)));
                //t.opEquals(1, (new RVector3(0,0)).distance(new RVector(1,0)));
                //t.opEquals(0, (new RVector3(0,0)).distance(new RVector(0,0)));
            });
        }

    }
}
