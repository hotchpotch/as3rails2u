package com.rails2u.utils {
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.geom.Matrix;

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
    }
}
