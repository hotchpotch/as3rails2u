package com.rails2u.typofy {
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.display.BitmapData;
    import mx.containers.Canvas;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import flash.filters.BlurFilter;
    import flash.display.Bitmap;
    import flash.filters.BitmapFilterQuality;

    public class TypofyCharSprite extends Sprite {
        public static const PADDING_MAGIC_NUMBER:int = 2; // why? Bug? (193249) 

        public var textField:TextField;
        public var typofy:Typofy;
        
        
        private var _char:String;
        public function get char():String {
            return _char;
        }
        
        public function set char(newchar:String):void {
            this.textField.text = newchar;
            this._char = newchar;
            if (bitmapFont) renderBitmapFont();
        }

        public function setDefaultChar():void {
            char = defaultChar;
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
        
        public var defaultChar:String;
        public function TypofyCharSprite(_char:String, typofy:Typofy, _index:uint, boundaries:Rectangle) {
            super();
            textField = new TextField;
            textField.selectable = false;
            textField.embedFonts = typofy.embedFonts;
            this.addChild(textField);
            this.boundaries = boundaries;

            this.charIndex = _index;
            this.typofy = typofy;

            init();
            defaultChar = _char;
            setDefaultChar();
        }

        public function drawBorder(... args):void {
            if (args.length > 0) {
               graphics.lineStyle.apply(null, args);
            } else {
               graphics.lineStyle(0, 0xEEEEEE);
            }
            graphics.drawRect(-boundaries.width / 2, -boundaries.height / 2, boundaries.width, boundaries.height);
        }

        public function drawBorderWithCrossLine(... args):void {
            drawBorder.apply(this, args);
            graphics.moveTo(-boundaries.width / 2, -boundaries.height / 2);
            graphics.lineTo(boundaries.width / 2, boundaries.height / 2);
            graphics.moveTo(boundaries.width / 2, -boundaries.height / 2);
            graphics.lineTo(-boundaries.width / 2, boundaries.height / 2);
        }

        public var bitmapFont:Bitmap;
        public function replaceBitmap(blurX:Number = 2, blurY:Number = 2, blurQuality:uint = 3):void {
            if (!bitmapFont) {
                renderBitmapFont(blurX, blurY, blurQuality);
                textField.visible = false;
            }
        }

        private function renderBitmapFont(blurX:Number = 2, blurY:Number = 2, blurQuality:uint = 1):void {
            if (bitmapFont) {
                removeChild(bitmapFont);
            }
            var bd:BitmapData = getAAText(textField, blurX, blurY, blurQuality);
            bitmapFont = new Bitmap(bd, 'never', true);
            bitmapFont.x = textField.x;
            bitmapFont.y = textField.y;
            addChild(bitmapFont);
        }

        protected function init():void {
            var textFormat:TextFormat = typofy.getTextFormat(this.charIndex);

            this.x = boundaries.x + boundaries.width / 2;
            this.y = boundaries.y + boundaries.height / 2;
            this._centerPoint = new Point(this.x, this.y);

            textField.x -= boundaries.width / 2 + PADDING_MAGIC_NUMBER;
            textField.y -= boundaries.height / 2 + PADDING_MAGIC_NUMBER;

            textField.width = boundaries.width + PADDING_MAGIC_NUMBER * 2;
            textField.height = boundaries.height + PADDING_MAGIC_NUMBER * 2;

            this.width = boundaries.width + PADDING_MAGIC_NUMBER * 2;
            this.height = boundaries.height + PADDING_MAGIC_NUMBER * 2;

            textFormat.align = 'left';
            textField.defaultTextFormat = textFormat;
        }

        public static var AA_MARGIN:Number = 16;
        public static var AA_BMP_MAX:Number = 2800;
        public static var AA_MAX_SCALE:Number = 3;
        // Device font apply Anti-Alias tips by F-SITE.
        // http://f-site.org/articles/2007/04/08165536.html
        public static function getAAText(textField:TextField, blurX:Number = 2, blurY:Number = 2, blurQuality:uint = 2):BitmapData {
            var aaWidth:Number  = textField.textWidth + AA_MARGIN;
            var aaHeight:Number = textField.textHeight + AA_MARGIN;
            var aaScale:Number = Math.min(AA_MAX_SCALE, Math.min(AA_BMP_MAX / aaWidth, AA_BMP_MAX / aaHeight));

            var bmpCanvas:BitmapData = new BitmapData(aaWidth * aaScale, aaHeight * aaScale, true, 0x00000000);
            var bmpResult:BitmapData = new BitmapData(aaWidth, aaHeight, true, 0x00000000);

            var myMatrix:Matrix = new Matrix();
            myMatrix.scale(aaScale, aaScale);
            bmpCanvas.draw(textField, myMatrix);

            var myFilter:BlurFilter = new BlurFilter(blurX, blurY, blurQuality);
            bmpCanvas.applyFilter(bmpCanvas, new Rectangle(0, 0, bmpCanvas.width, bmpCanvas.height), new Point(0, 0), myFilter);
            bmpCanvas.draw(textField, myMatrix);

            var myColor:ColorTransform = new ColorTransform();
            myColor.alphaMultiplier= 1.1;
            myMatrix.a = myMatrix.d = 1;
            myMatrix.scale(1 / aaScale, 1 / aaScale);
            bmpResult.draw(bmpCanvas, myMatrix, myColor);
            bmpResult.draw(bmpCanvas, myMatrix);
            bmpCanvas.dispose();

            return bmpResult;
        }
    }
}

