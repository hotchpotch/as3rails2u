package com.rails2u.layout {
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.DisplayObject;

    public class GridLayout {
        protected var _row:uint;
        protected var _column:uint;
        protected var _boxHeight:Number;
        protected var _boxWidth:Number;
        protected var _target:Sprite;
        protected var _boxes:Array;

        public function GridLayout(target:Sprite, row:uint, column:uint, boxWidth:Number, boxHeight:Number) {
            _target = target;
            _row = row;
            _column = column;
            _boxHeight = boxHeight;
            _boxWidth = boxWidth;
            _boxes = [];
            _boxes.map(function(...args):* { return new Array(_column); });

            for (var x:uint = 0; x < _row; x++) {
                var r:Array = [];
                for (var y:uint = 0; y < _column; y++) {
                    r.push(null);
                }
                _boxes.push(r);
            }
        }

        public static function fromSize(
            target:Sprite, width:Number, height:Number, boxWidth:Number, boxHeight:Number):GridLayout 
        {
            return new GridLayout(
                target,
                Math.floor(width / boxWidth),
                Math.floor(width / boxHeight),
                boxHeight,
                boxWidth
            );
        }

        public function get target():Sprite {
            return _target;
        }

        public function get row():uint {
            return _row;
        }

        public function get column():uint {
            return _column;
        }

        public function get boxHeight():Number {
            return _boxHeight;
        }

        public function get boxWidth():Number {
            return _boxWidth;
        }

        public function get layoutedObjects():Array {
            return [];
        }

        public function push(o:DisplayObject):void {
        }

        public function moveTo(r:uint, c:uint, toR:uint, toC:uint, setPosition:Boolean = true):Boolean {
            if (check(r, c) && !check(toR, toC)) {
                var o:DisplayObject = remove(r, c);
                setObject(toR, toC, o, setPosition);
                return true;
            } else {
                return false;
            }
        }

        public function remove(r:uint, c:uint):DisplayObject {
            var o:DisplayObject = getObject(r, c);
            _boxes[r][c] = null;
            target.removeChild(o);
            return o;
        }

        public function top(r:uint, c:uint):DisplayObject {
            return getObjectIgnoreError(r - 1, c);
        }

        public function setObject(
        r:uint, c:uint, o:DisplayObject, setPosition:Boolean = true):DisplayObject {
            check(r, c);
            _boxes[r][c] = o;
            if (setPosition) {
                o.x = r * boxWidth;
                o.y = c * boxHeight;
            }
            target.addChild(o);
            return o;
        }

        public function check(r:uint, c:uint):Boolean {
            if (r > row || c > column) 
                throw new LayoutError('Position [' + [r,c].toString() + '] is over in layout.');
            return !!_boxes[r][c];
        }

        public function checkAndError(r:uint, c:uint):void {
            if (!check(r, c)) throw new LayoutError('Position [' + [r,c].toString() + '] is not found.');
        }

        public function getObject(r:uint, c:uint):DisplayObject {
            checkAndError(r, c);
            return _boxes[r][c];
        }

        public function getObjectIgnoreError(r:uint, c:uint):DisplayObject {
            return _boxes[r][c];
        }

        public function get width():Number {
            return (_row - 1) * _boxWidth;
        }

        public function get height():Number {
            return (_column - 1) * _boxHeight;
        }

        public function createObjects(f:Function):void {
            var xPoint:Number;
            var yPoint:Number;
            for (var x:uint = 0; x < _row; x++) {
                xPoint = x * boxWidth;
                for (var y:uint = 0; y < _column; y++) {
                    yPoint = y * boxHeight;
                    log(x,y, xPoint, yPoint);
                    setObject(x, y, f.call(null, x, y, xPoint, yPoint), false);
                }
            }
        }

        public function each(f:Function, after:Function = null):* {
            var xPoint:Number;
            var yPoint:Number;
            for (var x:uint = 0; x < _row; x++) {
                xPoint = x * boxWidth;
                for (var y:uint = 0; y < _column; y++) {
                    yPoint = y * boxHeight;
                    f.call(null, x, y, xPoint, yPoint);
                }
            }
        }

        public function showPoints(size:Number = 5, setGraphics:Function = null):void {
            var g:Graphics = target.graphics;
            setGraphics ||= function(g:Graphics):void {
                g.lineStyle(0, 0x999999);
            }
            setGraphics(g);

            var xPoint:Number;
            var yPoint:Number;
            for (var x:uint = 0; x < _row; x++) {
                xPoint = x * boxWidth;
                for (var y:uint = 0; y < _column; y++) {
                    yPoint = y * boxHeight;
                    g.moveTo(-size + xPoint, yPoint);
                    g.lineTo(size + xPoint, yPoint);

                    g.moveTo(xPoint, -size + yPoint);
                    g.lineTo(xPoint, size + yPoint);
                }
            }
        }

    }
}
