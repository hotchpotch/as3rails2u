package com.rails2u.swflayer {
    import flash.external.ExternalInterface;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    import flash.errors.IOError;
    import flash.errors.IllegalOperationError;

    public dynamic class SWFLayer extends Proxy {
        private static var _instance:SWFLayer;
        private static var _style:SWFStyle;

        public function SWFLayer() {
            if (SWFLayer._instance) throw (new ArgumentError('Please access SWFLayer.getInstance()'));
            if (!ExternalInterface.available) throw (new IllegalOperationError('ExternalInterface.available should be true.'));

            // defineJSFuncitons();

            var x:String = getProperty('offsetTop');
            var y:String = getProperty('offsetLeft');
            _style = new SWFStyle(this);
            //this.x = Number(x);
            //this.y = Number(y);
            //this.height = this.clientHeight;
            //this.width = this.clientWidth;
            if (_style.position != 'absolute') _style.position = 'absolute';
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

        public function fitInBrowser():void {
            this.x = this.scrollLeft;
            this.y = this.scrollTop;
            this.width = this.browserWidth;
            this.height = this.browserHeight;
        }

        public function get browserWidth():Number {
            //return execExternalInterface('return document.body.clientWidth') as Number; // IOError ;(
            return execExternalInterface('return document.getElementsByTagName("body")[0].clientWidth') as Number;
        }

        public function get browserHeight():Number {
            return execExternalInterface('return document.getElementsByTagName("body")[0].clientHeight') as Number;
        }

        public function get htmlWidth():Number {
            return execExternalInterface('return document.getElementsByTagName("html")[0].clientWidth') as Number;
        }

        public function get htmlHeight():Number {
            return execExternalInterface('return document.getElementsByTagName("html")[0].clientHeight') as Number;
        }

        public function get scrollTop():Number {
            return execExternalInterface('return window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop') as Number;
        }

        public function get scrollLeft():Number {
            return execExternalInterface('return window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft') as Number;
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
            return execExternalInterface(cmd);
        }

        public static function execExternalInterface(cmd:String):* {
            cmd = "(function() {" + cmd + ";})";
            return ExternalInterface.call(cmd);
        }

       override flash_proxy function setProperty(name:*, value:*):void {
           this.setProperty(name, value);
       }

       override flash_proxy function getProperty(name:*):* {
           return this.getProperty(name);
       }

       override flash_proxy function callProperty(name:*, ...rest):* {
       }

       private function getterClosure(name:String):Function {
           var self:SWFLayer = this;
           return function():* { return self[name] };
       }

       private function defineJSFuncitons():void {
           ExternalInterface.addCallback('fitInBrowser', fitInBrowser);

           var a:Array = ['browserWidth', 'browserHeight', 'htmlWidth', 'htmlHeight', 'scrollTop', 'scrollLeft', 'x', 'y', 'width', 'height'];
           for each (var closureName:String in a) {
               ExternalInterface.addCallback(closureName, getterClosure(closureName));
           }
       }
    }
}
