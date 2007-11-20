package com.rails2u.component {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.text.TextField;

    public class SimpleButton extends Sprite {
        public function SimpleButton() {
            init();
        }

        public var defaultColorTransform:ColorTransform;
        public var tmpColorTransform:ColorTransform;
        public var openURL:String;
        public var targetURLType:String = 'blank';
        
        protected var _textField:TextField;
        
        public function get textField():TextField {
            return _textField;
        }
        
        public function set textField(__textField:TextField):void {
            addChild(__textField);
            __textField.mouseEnabled = false;
            _textField = __textField;
        }

        
        protected var _text:String;
        public function get text():String {
            return _text;
        }
        
        public function set text(__text:String):void {
            _text = __text;
            if (!textField) textField = new TextField();

            textField.text = _text;
            autoTextPosition();
        }

        public function autoTextPosition():void {
            textField.width = textField.textWidth;
            textField.height = textField.textHeight;
        }
        

        public function drawBackground(width:Number, height:Number, round:Number = NaN):void {
            if (isNaN(round)) {
                graphics.drawRect(0, 0, width, height);
            } else {
                graphics.drawRoundRect(0, 0, width, height, round, round);
            }
        }

        public function textCentering():void {
            if (textField) {
                if (textField.textHeight < height) {
                    textField.y = (height - textField.textHeight) / 2;
                }

                if (textField.textWidth < width) {
                    textField.x = (width - textField.textWidth) / 2;
                }
            }
        }

        protected function init():void {
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        }

        protected function mouseDownHandler(e:MouseEvent):void {
            if (openURL)
                navigateToURL(new URLRequest(openURL), targetURLType);
        }

        protected function mouseOverHandler(e:MouseEvent):void {
            if (defaultColorTransform) {
                tmpColorTransform = transform.colorTransform;
                transform.colorTransform = defaultColorTransform;
            }
        }

        protected function mouseOutHandler(e:MouseEvent):void {
            if (tmpColorTransform) {
                transform.colorTransform = tmpColorTransform;
            }
        }
    }
}
