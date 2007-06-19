package com.rails2u.typofy {
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.geom.Point;
    import com.rails2u.utils.DrawUtil;
    public class TypofyCharSprite extends Sprite {

        public var textField:TextField;
        public var typofy:Typofy;
        public var row:uint;
        public var col:uint;
        public var boundaries:Rectangle;
        public var index:uint;
        
        protected var _centerPoint:Point;
        
        public function get centerPoint():Point {
            return _centerPoint;
        }
        
        public function TypofyCharSprite(_char:String, typofy:Typofy, index:uint, boundaries:Rectangle) {
            textField = new TextField;
            this.addChild(textField);
            this.boundaries = boundaries;

            this.index = index;
            this.typofy = typofy;

            init();
            textField.text = _char;
        }

        public function drawBorder():void {
            graphics.lineStyle(0, 0xEEEEEE);
            graphics.drawRect(-boundaries.width / 2, -boundaries.height / 2, boundaries.width, boundaries.height);
        }

        protected function init():void {
            var textFormat:TextFormat = typofy.getTextFormat(index);
            this.row = typofy.getFirstCharInParagraph(index);
            this.col = typofy.getLineIndexOfChar(index);

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

