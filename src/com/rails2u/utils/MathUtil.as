package com.rails2u.utils
{
    public class MathUtil 
    {
        public static function randomPlusMinus(val:Number = 1):Number {
            if (randomBoolean() ) {
                return val;
            } else {
                return val * -1;
            }
        }

        /*
         * randomBoolean(-100, 100); // retun value is between -100 and 100;
         */
        public static function randomBetween(s:Number, e:Number = 0):Number {
            return s + (e - s) * Math.random();
        }

        /*
         * randomBetween(); // return value is true or false.
         */
        public static function randomBoolean():Boolean {
            return (Math.round(Math.random()) == 1) ? true : false;
        }

        /*
         * randomPickup(1,2,3,4); // return value is 1 or 2 or 3 or 4
         */
        public static function randomPickup(... args):Object {
            var len:uint = args.length;
            if (len == 1) {
                return args[0];
            } else {
                return args[Math.round(Math.random() * (len - 1))];
            }
        }

        /*
         * var cycleABC = MathUtil.cycle('a', 'b', 'c');
         * cycleABC(); // 'a'
         * cycleABC(); // 'b'
         * cycleABC(); // 'c'
         * cycleABC(); // 'a'
         * cycleABC(); // 'b'
         */
        public static function cycle(... args):Function {
            var len:uint = args.length;
            var i:uint = 0;
            if (len == 1) { 
                return function():Object {
                    return args[0];
                }
            } else {
                return function():Object {
                    var res:Object = args[i];
                    i++;
                    if (i >= len) i = 0;
                    return res;
                };
            }
        }

        public static function bezier3(t:Number, x0:Number, x1:Number, x2:Number, x3:Number):Number {
             return x0 * Math.pow(1-t, 3) + 3 * x1 * t *Math.pow(1-t, 2) + 3 * x2 * Math.pow(t, 2) * 1-t + x3 * Math.pow(t, 3);
        }

        public static function bezierN(t:Number, points:Array):Number {
            var res:Number = 0;
            var len:uint = points.length;
            var tm:Number = 1 - t;
            for (var i:uint=0; i < len;i++) {
                var pos:Number = points[i];
                var tmp:Number = 1.0;
                var a:Number = len - 1;
                var b:Number = i;
                var c:Number = a - b;
                while (a > 1) {
                    if(a > 1) tmp *= a; a -= 1;
                    if(b > 1) tmp /= b; b -= 1;
                    if(c > 1) tmp /= c; c -= 1;
                }
                tmp *= Math.pow(t, i) * Math.pow(tm, len -1 -i);
                res += tmp * pos;
            }
            return res;
        }
    }
}

