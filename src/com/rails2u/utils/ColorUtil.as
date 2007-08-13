package com.rails2u.utils
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

        public static function sinArray(start:int = 255, end:int = 0, cycle:uint = 90):Array {
            var f:Function = sinGenerator(start, end, cycle);
            var a:Array = [];
            for (var i:uint = 0; i < cycle; i++) {
                // a.push(f(
            }
        }

        public static function sinGenerator(start:int = 255, end:int = 0, cycle:uint = 90):Function {
            var times:uint = 0;
            var diff:int = start - end;
            var p:Number;
            return function():uint {
                p = (Math.sin(Math.PI/2 + Math.PI * 2 * (360 / cycle * times) / 360) + 1) / 2;
                times++;
                if(times >= cycle) times = 0;
                return end + (diff * p);
            }
        }
    }
}
