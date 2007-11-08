package com.rails2u.core {
    public class Enumerable {
        public static function implementation(klass:Class):void {
            klass.prototype.zip = function(...args):Enumerable { 
                return zip.apply(null, [klass].concat(args));
            };
        }

        public static function zip(t:*, ...args):Enumerator {
           log(1, args, 4);
           var ary:Array = getValues(t);
           var res:Array = [];
           var num:uint = Math.min.apply(null,
               [ary.length].concat(args.map(function(e:*, ...a):Number { return e.length })));

           args = args.map(function(e:*, ...a):Array { return getValues(e, num) });
           for (var i:uint = 0; i < num; i++) {
               var r:Array = [ary[i]];
               for each(var a:Array in args) {
                   r.push(a[i]);
               }
               res.push(r);
           }
           return new Enumerator(res);
        }

        public static function cycle(t:*):Enumerator {
           var ary:Array = getValues(t);
           return new Enumerator(ary, iCycle, valReturn(true), valReturn(Infinity));
        }

        private static function iCycle(e:Enumerator):* {
            if(! (e._ary.length > e.index)) {
                e.rewind();
            }
            return e._ary[e.index++];
        }

        private static function valReturn(v:*):Function {
            return function(...args):* {
                return v;
            }
        }

        public static function take(t:*, maxValue:Number = Infinity):Enumerator {
            return new Enumerator(getValues(t, maxValue));
        }

        private static function getValues(t:*, maxValue:Number = Infinity):Array {
            var res:Array = [];
            try {
                if (t is Array) {
                    t.forEach(function(e:*, i:int, ...args):void { 
                        if (i++ > maxValue) throw new StopIteration;
                        res.push(e);
                    });
                } else {
                    var i:uint = 0;
                    t.each(function(e:*, ...args):void { 
                        if (i++ > maxValue) throw new StopIteration;
                        res.push(e) 
                    });
                }
            } catch(e:StopIteration) {
                //
            }
            return res;
        }
    }
}
