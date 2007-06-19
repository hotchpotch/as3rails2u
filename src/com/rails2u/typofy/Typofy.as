package com.rails2u.typofy {
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public class Typofy extends TextField {
        protected var chars:Array = [];
        protected var container:Sprite;
        private var inited:Boolean = false;
        public const PADDING_MAGIC_NUMBER:int = 2; // why?

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
                var tSprite:Typofy;
                while (tSprite = chars.pop()) 
                    tSprite.parent.removeChild(tSprite);

                var bounds:Rectangle = this.getBounds(this);
                inited = true;
                container ||= new Sprite;
                var ary:Array = this.text.split('');
                var l:Number = ary.length - 1;

                for (var charIndex:uint = 0; charIndex <= l; charIndex++) {
                    var c:String = ary[charIndex];

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
                    chars.push(mSprite);
                    container.addChild(mSprite);
                }
                container.x = this.x;
                container.y = this.y;

                parent.addChild(container);
                this.visible = false;
            }
        }

        public function run(func:Function, comp:Function = null):void {
            init();
            for (var charIndex:uint = 0; charIndex <= chars.length; charIndex++) {
                func(chars[charIndex]);
            }
        }
    }
}
