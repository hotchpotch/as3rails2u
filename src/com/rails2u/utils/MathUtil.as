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

    }
}

