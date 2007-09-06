package com.rails2u.swflayer {
    import flash.external.ExternalInterface;
    public class SWFLayer {
        public static const AUTO:String = 'auto';
        public static function get objectID():String {
            return ExternalInterface.objectID;
        }

        public static function initialize(position:String = 'absolute'):void {
            var x:String = getProperty('offsetTop');
            var y:String = getProperty('offsetLeft');
            setStyle('x', x);
            setStyle('y', y);
            setStyle('height', AUTO);
            setStyle('width', AUTO);
            setStyle('position', position);
        }

        public static function set width(value:Number):void {
            if (isNaN(value)) {
                setStyle('width', AUTO);
            } else {
                setStyle('width', value.toString());
            }
        }

        public static function get width():Number {
            return Number(getStyle('width'));
        }

        public static function set height(value:Number):void {
            if (isNaN(value)) {
                setStyle('height', AUTO);
            } else {
                setStyle('height', value.toString());
            }
        }

        public static function get height():Number {
            return Number(getStyle('height'));
        }

        public static function set x(value:Number):void {
            setStyle('left', value.toString());
        }

        public static function get x():Number {
            return Number(getStyle('left'));
        }

        public static function set y(value:Number):void {
            setStyle('top', value.toString());
        }

        public static function get y():Number {
            return Number(getStyle('top'));
        }

        public static function layerExec(str:String):* {
            var cmd:String = "return document.getElementById('" + objectID + "')." + str;
            return exec(cmd);
        }

        public static function setProperty(name:String, value:String):void {
            layerExec(name + ' = "' + value + '"');
        }

        public static function getProperty(name:String):* {
            return layerExec(name);
        }

        public static function setStyle(style:String, value:String):void {
            layerExec('style.' + style + ' = "' + value + '"');
        }

        public static function getStyle(style:String):* {
            return layerExec('style.' + style);
        }

        public static function exec(cmd:String):* {
            var cmd:String = "(function() {" + cmd + ";})()";
            log(cmd);
            return ExternalInterface.call(cmd);
        }
    }
}
