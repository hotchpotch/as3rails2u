package com.rails2u.swflayer {
    import flash.external.ExternalInterface;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    internal dynamic class SWFStyle extends Proxy {
        public static const AUTO:String = 'auto';

        private var layer:SWFLayer;
        public function SWFStyle(layer:SWFLayer) {
            this.layer = layer;
        }

        public function setStyle(style:String, value:String):void {
            layer.exec('style.' + style + ' = "' + value + '"');
        }

        public function getStyle(style:String):* {
            return layer.exec('style.' + style);
        }

        override flash_proxy function setProperty(name:*, value:*):void {
            this.setStyle(name, value);
        }

        override flash_proxy function getProperty(name:*):* {
            return this.getStyle(name);
        }
    }
}
