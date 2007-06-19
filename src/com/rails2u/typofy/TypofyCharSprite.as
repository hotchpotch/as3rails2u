package com.rails2u.typofy {
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class TypofyCharSprite extends Sprite {

        public var textField:TextField;
        public var typofy:Typofy;
        
        
        private var _char:String;
        public function get char():String {
            return _char;
        }
        
        public function set char(newchar:String):void {
            this.textField.text = newchar;
            this._char = newchar;
        }

        public function setDefaultChar():void {
            this.textField.text = _char;
        }

        public function get row():uint {
            return this.charIndex - typofy.getLineOffset(col);
        }

        public function get col():uint {
            return typofy.getLineIndexOfChar(this.charIndex);
        }

        public var boundaries:Rectangle;
        public var charIndex:uint;
         
        public var extra:Object = {};
        
        protected var _centerPoint:Point;
        
        public function get centerPoint():Point {
            return _centerPoint;
        }
        
        public function TypofyCharSprite(_char:String, typofy:Typofy, _index:uint, boundaries:Rectangle) {
            super();
            textField = new TextField;
            textField.selectable = false;
            this.addChild(textField);
            this.boundaries = boundaries;

            this.charIndex = _index;
            this.typofy = typofy;

            init();
            this.char = _char;
        }

        public function drawBorder():void {
            graphics.lineStyle(0, 0xEEEEEE);
            graphics.drawRect(-boundaries.width / 2, -boundaries.height / 2, boundaries.width, boundaries.height);
        }

        protected function init():void {
            var textFormat:TextFormat = typofy.getTextFormat(this.charIndex);

            this.x = boundaries.x + boundaries.width / 2;
            this.y = boundaries.y + boundaries.height / 2;
            this._centerPoint = new Point(this.x, this.y);

            textField.x -= boundaries.width / 2;
            textField.y -= boundaries.height / 2;

            textFormat.align = 'left';
            textField.defaultTextFormat = textFormat;
        }
    }
}

