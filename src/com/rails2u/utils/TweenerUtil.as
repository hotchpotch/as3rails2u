package com.rails2u.utils {
    import caurina.transitions.Equations;
    public class TweenerUtil {

        /*
        public static function easingSerial(...easings):Function {
            init();
            var len:uint = easings.length;
            if (len < 2) throw new ArgumentError('needs 2 =< args.');

            var easing:*;
            return function easeOutInBounce(t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                var i:uint = Math.floor(t/d*len);

                easing = easings[i];
                if (easing is String){
                    easing = transitions[easing.toLowerCase()];
                    easings[i] = easing;
                }
                return easing.call(null, 
                t * len, 
                b + ((len-i)/len * (c-b)), 
                c, 
                d * len, 
                p_params);
            }
        }
        */

        public static function easingParallel(...easings):Function {
            init();
            var len:uint = easings.length;
            if (len < 2) throw new ArgumentError('needs 2 =< args.');

            var easing:*;
            return function easeOutInBounce(t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                var res:Number = 0;
                for (var i:uint = 0; i < len; i++) {
                    easing = easings[i];
                    if (easing is String){
                        easing = transitions[easing.toLowerCase()];
                        easings[i] = easing;
                    }
                    res += easing.call(null, t, b/len, c/len, d, p_params);
                }
                return res;
            };
        }

        private static var inited:Boolean = false;
        public static var transitions:Object = {};
        public static function init():void {
            if (!inited) {
                registerTransition("easenone",          Equations.easeNone);
                registerTransition("linear",            Equations.easeNone);      // mx.transitions.easing.None.easeNone
                registerTransition("easeinquad",        Equations.easeInQuad);    // mx.transitions.easing.Regular.easeIn
                registerTransition("easeoutquad",       Equations.easeOutQuad);   // mx.transitions.easing.Regular.easeOut
                registerTransition("easeinoutquad",     Equations.easeInOutQuad); // mx.transitions.easing.Regular.easeInOut
                registerTransition("easeoutinquad",     Equations.easeOutInQuad);
                registerTransition("easeincubic",       Equations.easeInCubic);
                registerTransition("easeoutcubic",      Equations.easeOutCubic);
                registerTransition("easeinoutcubic",    Equations.easeInOutCubic);
                registerTransition("easeoutincubic",    Equations.easeOutInCubic);
                registerTransition("easeinquart",       Equations.easeInQuart);
                registerTransition("easeoutquart",      Equations.easeOutQuart);
                registerTransition("easeinoutquart",    Equations.easeInOutQuart);
                registerTransition("easeoutinquart",    Equations.easeOutInQuart);
                registerTransition("easeinquint",       Equations.easeInQuint);
                registerTransition("easeoutquint",      Equations.easeOutQuint);
                registerTransition("easeinoutquint",    Equations.easeInOutQuint);
                registerTransition("easeoutinquint",    Equations.easeOutInQuint);
                registerTransition("easeinsine",        Equations.easeInSine);
                registerTransition("easeoutsine",       Equations.easeOutSine);
                registerTransition("easeinoutsine",     Equations.easeInOutSine);
                registerTransition("easeoutinsine",     Equations.easeOutInSine);
                registerTransition("easeincirc",        Equations.easeInCirc);
                registerTransition("easeoutcirc",       Equations.easeOutCirc);
                registerTransition("easeinoutcirc",     Equations.easeInOutCirc);
                registerTransition("easeoutincirc",     Equations.easeOutInCirc);

                registerTransition("easeinexpo",        Equations.easeInExpo);        // mx.transitions.easing.Strong.easeIn
                registerTransition("easeoutexpo",       Equations.easeOutExpo);       // mx.transitions.easing.Strong.easeOut
                registerTransition("easeinoutexpo",     Equations.easeInOutExpo);     // mx.transitions.easing.Strong.easeInOut
                registerTransition("easeoutinexpo",     Equations.easeOutInExpo);

                registerTransition("easeinelastic",     Equations.easeInElastic);     // mx.transitions.easing.Elastic.easeIn
                registerTransition("easeoutelastic",    Equations.easeOutElastic);    // mx.transitions.easing.Elastic.easeOut
                registerTransition("easeinoutelastic",  Equations.easeInOutElastic);  // mx.transitions.easing.Elastic.easeInOut
                registerTransition("easeoutinelastic",  Equations.easeOutInElastic);

                registerTransition("easeinback",        Equations.easeInBack);        // mx.transitions.easing.Back.easeIn
                registerTransition("easeoutback",       Equations.easeOutBack);       // mx.transitions.easing.Back.easeOut
                registerTransition("easeinoutback",     Equations.easeInOutBack);     // mx.transitions.easing.Back.easeInOut
                registerTransition("easeoutinback",     Equations.easeOutInBack);

                registerTransition("easeinbounce",      Equations.easeInBounce);      // mx.transitions.easing.Bounce.easeIn
                registerTransition("easeoutbounce",     Equations.easeOutBounce);     // mx.transitions.easing.Bounce.easeOut
                registerTransition("easeinoutbounce",   Equations.easeInOutBounce);   // mx.transitions.easing.Bounce.easeInOut
                registerTransition("easeoutinbounce",   Equations.easeOutInBounce);
                inited = true;
            }
        }

        public static function registerTransition(name:String, easing:Function):void {
            transitions[name.toLowerCase()] = easing;
        }
    }
}
    /*
     * @param t      Current time (in frames or seconds).
     * @param b      Starting value.
     * @param c      Change needed in value.
     * @param d      Expected easing duration (in frames or seconds).
     Tweener.registerTransition("easenone",          easeNone);
     Tweener.registerTransition("linear",            easeNone);      // mx.transitions.easing.None.easeNone

     Tweener.registerTransition("easeinquad",        easeInQuad);    // mx.transitions.easing.Regular.easeIn
     Tweener.registerTransition("easeoutquad",       easeOutQuad);   // mx.transitions.easing.Regular.easeOut
     Tweener.registerTransition("easeinoutquad",     easeInOutQuad); // mx.transitions.easing.Regular.easeInOut
     Tweener.registerTransition("easeoutinquad",     easeOutInQuad);

     Tweener.registerTransition("easeincubic",       easeInCubic);
     Tweener.registerTransition("easeoutcubic",      easeOutCubic);
     Tweener.registerTransition("easeinoutcubic",    easeInOutCubic);
     Tweener.registerTransition("easeoutincubic",    easeOutInCubic);

     Tweener.registerTransition("easeinquart",       easeInQuart);
     Tweener.registerTransition("easeoutquart",      easeOutQuart);
     Tweener.registerTransition("easeinoutquart",    easeInOutQuart);
     Tweener.registerTransition("easeoutinquart",    easeOutInQuart);

     Tweener.registerTransition("easeinquint",       easeInQuint);
     Tweener.registerTransition("easeoutquint",      easeOutQuint);
     Tweener.registerTransition("easeinoutquint",    easeInOutQuint);
     Tweener.registerTransition("easeoutinquint",    easeOutInQuint);

     Tweener.registerTransition("easeinsine",        easeInSine);
     Tweener.registerTransition("easeoutsine",       easeOutSine);
     Tweener.registerTransition("easeinoutsine",     easeInOutSine);
     Tweener.registerTransition("easeoutinsine",     easeOutInSine);

     Tweener.registerTransition("easeincirc",        easeInCirc);
     Tweener.registerTransition("easeoutcirc",       easeOutCirc);
     Tweener.registerTransition("easeinoutcirc",     easeInOutCirc);
     Tweener.registerTransition("easeoutincirc",     easeOutInCirc);

     Tweener.registerTransition("easeinexpo",        easeInExpo);        // mx.transitions.easing.Strong.easeIn
     Tweener.registerTransition("easeoutexpo",       easeOutExpo);       // mx.transitions.easing.Strong.easeOut
     Tweener.registerTransition("easeinoutexpo",     easeInOutExpo);     // mx.transitions.easing.Strong.easeInOut
     Tweener.registerTransition("easeoutinexpo",     easeOutInExpo);

     Tweener.registerTransition("easeinelastic",     easeInElastic);     // mx.transitions.easing.Elastic.easeIn
     Tweener.registerTransition("easeoutelastic",    easeOutElastic);    // mx.transitions.easing.Elastic.easeOut
     Tweener.registerTransition("easeinoutelastic",  easeInOutElastic);  // mx.transitions.easing.Elastic.easeInOut
     Tweener.registerTransition("easeoutinelastic",  easeOutInElastic);

     Tweener.registerTransition("easeinback",        easeInBack);        // mx.transitions.easing.Back.easeIn
     Tweener.registerTransition("easeoutback",       easeOutBack);       // mx.transitions.easing.Back.easeOut
     Tweener.registerTransition("easeinoutback",     easeInOutBack);     // mx.transitions.easing.Back.easeInOut
     Tweener.registerTransition("easeoutinback",     easeOutInBack);

     Tweener.registerTransition("easeinbounce",      easeInBounce);      // mx.transitions.easing.Bounce.easeIn
     Tweener.registerTransition("easeoutbounce",     easeOutBounce);     // mx.transitions.easing.Bounce.easeOut
     Tweener.registerTransition("easeinoutbounce",   easeInOutBounce);   // mx.transitions.easing.Bounce.easeInOut
     Tweener.registerTransition("easeoutinbounce",   easeOutInBounce);
     */
