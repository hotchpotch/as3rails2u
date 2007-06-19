package com.rails2u.typofy {
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public class Typofy extends TextField {
        public var charSprites:Array = [];
        public var container:Sprite;
        private var inited:Boolean = false;
        public const PADDING_MAGIC_NUMBER:int = 2; // why? Bug? (193249) 

        public function Typofy()
        {
            super();
        }

        public override function set text(t:String):void {
            inited = false;
            super.text = t;
        }

        public function init():void {
            if (!inited) {
                this.clear();

                var bounds:Rectangle = this.getBounds(this);
                inited = true;
                container ||= new Sprite;
                var l:Number = this.text.length;

                for (var charIndex:uint = 0; charIndex < l; charIndex++) {
                    var c:String = this.text.charAt(charIndex);

                    var boundaries:Rectangle = this.getCharBoundaries(charIndex);
                    if (! (boundaries && bounds.containsRect(boundaries))) {
                        continue;
                    }
                    boundaries.x -= PADDING_MAGIC_NUMBER;
                    boundaries.y -= PADDING_MAGIC_NUMBER;

                    var mSprite:TypofyCharSprite = new TypofyCharSprite(c, 
                        this,
                        charIndex,
                        boundaries
                    );
                    charSprites.push(mSprite);
                    container.addChild(mSprite);
                }
                container.x = this.x;
                container.y = this.y;

                parent.addChild(container);
                this.visible = false;
            }
        }

        public function start(func:Function):void {
            init();
            for (var charIndex:uint = 0; charIndex < charSprites.length; charIndex++) {
                func(charSprites[charIndex]);
            }
        }

        public function stop():void {
            for (var charIndex:uint = 0; charIndex < charSprites.length; charIndex++) {
                charSprites[charIndex].visible = false;
            }
            this.visible = true;
        }

        public function clear():void {
            var tSprite:TypofyCharSprite;
            while (tSprite = charSprites.pop()) {
                tSprite.parent.removeChild(tSprite);
                tSprite = null;
            }
            this.visible = true;
        }
    }
}
