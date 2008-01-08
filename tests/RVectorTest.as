package {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import com.rails2u.math.*;
    import flash.geom.Point;
    import flash.display.Shape;

    [SWF(frameRate=60, background=0x000000)]
    public class RVectorTest extends Sprite {
        public function RVectorTest (){
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            rvector();
        }

        public function rvector(): void {
            var t:SimpleTest = new SimpleTest('RVector');
            //t.verbose = true;
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
                
                t.equals(v1.dot(v2), 4);
                t.equals(v2.dot(v1), 4);

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

                // angle
                t.opEquals(-135, (new RVector(1,0).angle(new RVector(-1, 1))));
                var angle:Number = (new RVector(1,1).angle(new RVector(0.5, 1)));
                t.ok(angle > -45 && angle < -1);
                angle = (new RVector(1,1).angle(new RVector(1.5, 1)));
                t.ok(angle < 45 && angle > 1);
                angle = (new RVector(-1,-3).angle(new RVector(-3, -1)));
                t.ok(angle < -1 && angle > -90);
                angle = (new RVector(-3,-1).angle(new RVector(-1, -3)));
                t.ok(angle < 90 && angle > 1);

                // factory
                t.equals(new RVector(1,2), RVector.create(new Point(1,2)));
                t.ok(new Point(1,2).equals(RVector.create(new Point(1,2)).point()));
                var d:Shape = new Shape;
                d.x = 1;
                d.y = 2;
                t.equals(new RVector(1,2), RVector.create(d));
                t.equals(new RVector(1,2), RVector.create([1,2]));
                t.opEquals(null, RVector.create([1,2,3]));
            });
        }
    }
}
