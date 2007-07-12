package com.rails2u.mx {
    import mx.effects.Effect;
    import mx.effects.AnimateProperty;
    import mx.effects.easing.*;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import mx.events.TweenEvent;
    import mx.effects.Blur;
    import mx.effects.Rotate;
    import mx.utils.DescribeTypeCache;
    import mx.utils.DescribeTypeCacheRecord;
    import mx.effects.Parallel;

    public class mxTweener {
        private static const EASYING_CLASSES:Array = [
            Back, Circular, Elastic, Quartic, Sine,
            Bounce, Cubic, Exponential, Quadratic, Quintic
        ];

        public static const EASYING_FUNCTIONS:Object = createEasyingFunctions();

        private static function createEasyingFunctions():Object {
            var o:Object = {};
            o['linear'] = Linear.easeNone;
            for each(var klass:Object in EASYING_CLASSES) {
                var name:String = getQualifiedClassName(klass).replace(/^.*::/,'').toLocaleLowerCase();
                o['easein' + name] = klass['easeIn'];
                o['easeout' + name] = klass['easeOut'];
                o['easeinout' + name] = klass['easeInOut'];
            }
            return o;
        }

        public static function addTween(options:Object):Effect {
            var pa:Parallel = new Parallel();

            var ef:AnimateProperty = new AnimateProperty();
            var desc:XML = DescribeTypeCache.describeType(ef).typeDescription;
            var effectOptions:Object = {};

            for (var key:String in options) {
                if(
                    desc.variable.(@name == key).@name.toString() || 
                    desc.accessor.(@name == key && @access == 'readwrite').@name.toString()
                ) {
                    effectOptions[key] = options[key];
                    delete options[key];
                }
            }


            if (options.easing is Function) {
                effectOptions.easingFunction = options.easing;
                delete options.easing;
            } else if (options.easing is String){
                effectOptions.easingFunction = EASYING_FUNCTIONS[options.easing.toLocaleLowerCase()];
                delete options.easing;
            }

            var repeatReverseFlag:Boolean = false;
            if (options.repeatReverse) {
                repeatReverseFlag = true;
                delete options.repeatReverse;
            }

            if (options.properties) {
                var props:Object = options.properties;
                delete options.properties;
                for (var key:String in props) {
                    options[key] = props[key];
                }
            };

            for (var key:String in options) {
                var effect:AnimateProperty = createAnimateProperty(effectOptions);
                effect.property = key;
                if (options[key] is Array) {
                    effect.fromValue = options[key][0];
                    effect.toValue = options[key][1];
                } else {
                    effect.toValue = options[key];
                }
                pa.addChild(effect);
            }

            if(repeatReverseFlag) {
                for each(var eff:Effect in pa.children) {
                    // eff.repeatCount = 0;
                    eff.addEventListener(TweenEvent.TWEEN_END, tweenReverseHandler);
                }
            }

            return Effect(pa);
        }

        private static function createAnimateProperty(effectOptions:Object):AnimateProperty {
            var ef:AnimateProperty = new AnimateProperty();
            for (var key:String in effectOptions) {
                ef[key] = effectOptions[key];
            }
            return ef;
        }

        private static function tweenReverseHandler(e:TweenEvent):void {
            e.target.reverse();
        }
    }
}
