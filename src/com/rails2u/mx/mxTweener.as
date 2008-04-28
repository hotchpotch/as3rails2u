package com.rails2u.mx {
    import mx.effects.Effect;
    import mx.effects.AnimateProperty;
    import mx.effects.easing.*;
    import mx.effects.*;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import mx.events.TweenEvent;
    import mx.effects.Blur;
    import mx.effects.Rotate;
    import mx.utils.DescribeTypeCache;
    import mx.utils.DescribeTypeCacheRecord;
    import mx.effects.Parallel;
    import mx.effects.CompositeEffect;
    import mx.effects.Sequence;
    import mx.core.mx_internal;
    import mx.events.EffectEvent;
    import mx.effects.effectClasses.TweenEffectInstance;
    import mx.effects.TweenEffect;
    use namespace mx_internal;

    /*
     * prop はわけよう
     */
    public class mxTweener {
        private static const EASYING_CLASSES:Array = [
            Back, Circular, Elastic, Quartic, Sine,
            Bounce, Cubic, Exponential, Quadratic, Quintic
        ];

        private static const TWEEN_EFFECT_CLASSES:Array = [
            AnimateProperty, Blur, Dissolve, Fade, Glow, Move, Pause, Resize, Rotate, Zoom
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

        public static function tween(... args):Effect {
            if(args.length == 1) {
                if(args[0] is Array) {
                    var par:Parallel= new Parallel;
                    for each (var options:Object in args[0]) {
                        par.addChild(factoryTween(options));
                    }
                    return par;
                } else {
                    return factoryTween(args[0]);
                }
            }
            if(args.length > 1) {
                var seq:Sequence = new Sequence;
                for each (options in args) {
                    seq.addChild(factoryTween(options));
                }
                return seq;
            }
            return new CompositeEffect;
        }

        public static function factoryTween(options:Object):Effect {
            if (options.properties) {
                return animatePropertyTween(options);
            } else {
                return effectTween(options);
            }
        }

        public static function effectTween(options:Object):Effect {
            var klass:Class;
            if(options.klass as Class) {
                klass = options.klass;
            } else {
               klass = Class(getDefinitionByName('mx.effects.' + options.klass));
            }
            var ef:Effect = new klass();

            var desc:XML = DescribeTypeCache.describeType(ef).typeDescription;
            var effectOptions:Object = {};
            var key:String;
            for (key in options) {
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
            } else if (options.easing is String){
                effectOptions.easingFunction = EASYING_FUNCTIONS[options.easing.toLocaleLowerCase()];
            }

            ef = createEffect(klass, effectOptions);
            if(options.repeatReverse) {
                if(ef.repeatCount != 0) {
                    ef.addEventListener(TweenEvent.TWEEN_START, 
                            createRepeatCountHandler(ef.repeatCount));
                    ef.repeatCount = 0;
                }
                ef.addEventListener(TweenEvent.TWEEN_END, tweenReverseHandler);
            }
            return ef;
        }

        public static function animatePropertyTween(options:Object):Parallel {
            var parallel:Parallel = new Parallel();

            var ef:AnimateProperty = new AnimateProperty();
            var desc:XML = DescribeTypeCache.describeType(ef).typeDescription;
            var effectOptions:Object = {};

            var key:String;
            for (key in options) {
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
            } else if (options.easing is String){
                effectOptions.easingFunction = EASYING_FUNCTIONS[options.easing.toLocaleLowerCase()];
            }

            var properties:Object = options.properties;
            for (key in properties) {
                var effect:AnimateProperty = AnimateProperty(createEffect(AnimateProperty, effectOptions));
                effect.property = key;
                if (properties[key] is Array) {
                    effect.fromValue = properties[key][0];
                    effect.toValue = properties[key][1];
                } else {
                    effect.toValue = properties[key];
                }
                parallel.addChild(effect);
            }

            if(options.repeatReverse) {
                for each(var eff:Effect in parallel.children) {
                    // eff.repeatCount = 0;
                    // dirty code... :(
                    if(eff.repeatCount != 0) {
                        eff.addEventListener(TweenEvent.TWEEN_START, 
                          createRepeatCountHandler(eff.repeatCount));
                        eff.repeatCount = 0;
                    }
                    eff.addEventListener(TweenEvent.TWEEN_END, tweenReverseHandler);
                }
            }

            return parallel;
        }

        private static function createRepeatCountHandler(origRepCount:uint):Function {
            var repCount:uint = 0;
            return function(e:TweenEvent):void {
                if(origRepCount == repCount++) {
                    e.currentTarget.end();
                    repCount = 0;
                }
            }
        }

        private static function createEffect(klass:Class, effectOptions:Object):Effect {
            var ef:Effect = new klass();
            for (var key:String in effectOptions) {
                ef[key] = effectOptions[key];
            }
            return ef;
        }

        private static function tweenReverseHandler(e:TweenEvent):void {
            e.currentTarget.reverse();
        }
    }
}
