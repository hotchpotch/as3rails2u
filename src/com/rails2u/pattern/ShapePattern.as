package com.rails2u.pattern {
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import flash.display.Shape;

    public class ShapePattern {
        public static function fakeHalftone(
            t:DisplayObjectContainer, 
            rect:Rectangle,
            col:uint,
            padding:Number,
            xSizes:Array,
            ySizes:Array,
            afterShapeFunction:Function = null
        ):void {
            padding ||= Math.max.apply(null, [].concat(xSizes || []).concat(ySizes || []));
            var s:Shape;
            var xSize:Number;
            var ySize:Number;
            var radius:Number;

            for (var x:Number = rect.x + padding / 2; x <= rect.right; x += padding) {
                if (xSizes) {
                    if (xSizes[0] > xSizes[1]) {
                        xSize = xSizes[0] - (x - rect.x) / rect.width * (xSizes[0] - xSizes[1]);
                    } else {
                        xSize = xSizes[0] + (x - rect.x) / rect.width * (xSizes[1] - xSizes[0]);
                    }
                }
                for (var y:Number = rect.y + padding / 2; y <= rect.bottom; y += padding) {
                    if (ySizes) {
                        if (ySizes[0] > ySizes[1]) {
                            ySize = ySizes[0] - (y - rect.y) / rect.height * (ySizes[0] - ySizes[1]);
                        } else {
                            ySize = ySizes[0] + (y - rect.y) / rect.height * (ySizes[1] - ySizes[0]);
                        }
                    }
                    
                    if (isNaN(xSize) || isNaN(ySize)) {
                        radius = xSize || ySize;
                    } else {
                        radius = (xSize + ySize) / 2; 
                    }

                    s = new Shape();
                    s.graphics.beginFill(col);
                    s.graphics.drawCircle(0, 0, radius / 2);
                    s.graphics.endFill();
                    s.x = x;
                    s.y = y;
                    t.addChild(s);
                    if (afterShapeFunction is Function) afterShapeFunction(s);
                }
            }
        }
    }
}

