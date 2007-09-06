package com.rails2u.swflayer {
    import flash.external.ExternalInterface;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    public dynamic class SWFLayer extends Proxy {
        private static var _instance:SWFLayer;
        private static var _style:SWFStyle;
        public function SWFLayer(position:String = 'absolute') {
            if(SWFLayer._instance) throw(new ArgumentError('Please access SWFLayer.getInstance()'));

            var x:String = getProperty('offsetTop');
            var y:String = getProperty('offsetLeft');
            _style = new SWFStyle(this);
            this.x = Number(x);
            this.y = Number(y);
            this.height = NaN;
            this.width = NaN;
            if(_style.position != position) _style.position = position;

            //setStyle('x', x);
            //setStyle('y', y);
            //setStyle('height', SWFLayer.AUTO);
            //setStyle('width', SWFLayer.AUTO);
            //setStyle('position', position);
        }

        public function get style():SWFStyle {
            return _style;
        }

        public static function getInstance():SWFLayer {
            return _instance ||= new SWFLayer();
        }

        public static function get instance():SWFLayer {
            return _instance ||= new SWFLayer();
        }

        public function set width(value:Number):void {
            if (isNaN(value)) {
                _style.setStyle('width', SWFStyle.AUTO);
            } else {
                _style.setStyle('width', value.toString());
            }
        }

        public function get width():Number {
            return Number(_style.getStyle('width'));
        }

        public function set height(value:Number):void {
            if (isNaN(value)) {
                _style.setStyle('height', SWFStyle.AUTO);
            } else {
                _style.setStyle('height', value.toString());
            }
        }

        public function get height():Number {
            return Number(style.getStyle('height'));
        }

        public function set x(value:Number):void {
            _style.setStyle('left', value.toString());
        }

        public function get x():Number {
            try {
                return Number(_style.getStyle('left').toString().replace('px', ''));
            } catch(e:Error) {}
            return 0;
        }

        public function set y(value:Number):void {
            _style.setStyle('top', value.toString());
        }

        public function get y():Number {
            try {
                return Number(_style.getStyle('top').toString().replace('px', ''));
            } catch(e:Error) {}
            return 0;
        }

        public function get objectID():String {
            return ExternalInterface.objectID;
        }
        public function setProperty(name:String, value:String):void {
            exec(name + ' = "' + value + '"');
        }

        public function getProperty(name:String):* {
            return exec(name);
        }

        public function exec(cmd:String):* {
            cmd = "return document.getElementById('" + objectID + "')." + cmd;
            return execExternalIntarface(cmd);
        }

        public static function execExternalIntarface(cmd:String):* {
            cmd = "(function() {" + cmd + ";})";
            return ExternalInterface.call(cmd);
        }

       override flash_proxy function setProperty(name:*, value:*):void {
           this.setProperty(name, value);
       }

       override flash_proxy function getProperty(name:*):* {
           return this.getProperty(name);
       }
    }
}
