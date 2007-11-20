package com.rails2u.utils {
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    public class BitmapUtil {
        public static function mozaic(bd:BitmapData, scale:Number = 10, doubleParam:Number = 1.00):BitmapData {
            var tmp:Bitmap = new Bitmap();
            var miniBD:BitmapData = new BitmapData(bd.width/scale, bd.height/scale, true, 0x00FFFFF);
            var mozBD:BitmapData = new BitmapData(bd.width, bd.height, true, 0x00FFFFFF);

            tmp.bitmapData = bd.clone();

            miniBD.draw(tmp, new Matrix(1/scale,0,0,1/scale,0,0));
            tmp.bitmapData = miniBD;

            mozBD.draw(tmp, new Matrix(scale * doubleParam,0,0,scale * doubleParam,0,0));

            return mozBD;
        }

        public static function maskFill(bd:BitmapData, size:uint, col1:uint, col2:uint):void {
            var r:Rectangle = new Rectangle(0,0,size,size);
            for (var x:uint = 0; x < bd.width; x+=size) {
                for (var y:uint = 0; y < bd.height; y+=size) {
                    r.x = x;
                    r.y = y;
                    bd.fillRect(r, x / size % 2 ? y / size % 2 == 1 ? col1 : col2
                                                : y / size % 2 == 0 ? col1 : col2
                    );
                }
            }
        }
    }
}
