package rails2u.utils
{
    public class ColorUtil
    {
        public static function random(
            rMin:uint = 0,
            gMin:uint = 0,
            bMin:uint = 0,
            rMax:uint = 255,
            gMax:uint = 255,
            bMax:uint = 255
        ):uint 
        {
            return (uint(Math.random() * (rMax - rMin)) + rMin) << 16 | 
            (uint(Math.random() * (gMax - gMin)) + gMin) << 8 |
            (uint(Math.random() * (bMax - bMin)) + bMin);
        }
        
        public static function random32(
            rMin:uint = 0,
            gMin:uint = 0,
            bMin:uint = 0,
            aMin:uint = 0,
            rMax:uint = 255,
            gMax:uint = 255,
            bMax:uint = 255,
            aMax:uint = 255
        ):uint 
        {
            return (uint(Math.random() * (aMax - aMin)) + aMin) << 24 | 
            (uint(Math.random() * (rMax - rMin)) + rMin) << 16 | 
            (uint(Math.random() * (gMax - gMin)) + gMin) << 8 |
            (uint(Math.random() * (bMax - bMin)) + bMin);
        }
    }
}