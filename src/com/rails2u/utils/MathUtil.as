package com.rails2u.utils
{
    public class MathUtil 
    {
        public static function randomPlusMinus(val:Number = 1):Number {
            if (Math.random() > 0.5) {
                return val;
            } else {
                return val * -1;
            }
        }

        public static function randomRange(s:Number, e:Number = 0):Number {
            var ra:Number = e - s;
            return s + ra * Math.random();
        }
    }
}

