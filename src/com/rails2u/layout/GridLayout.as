package com.rails2u.layout {
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.DisplayObject;

    public class GridLayout {
        protected var _rowCount:uint;
        protected var _columnCount:uint;
        protected var _cellHeight:Number;
        protected var _cellWidth:Number;
        protected var _container:Sprite;
        protected var _cells:Array;
        public static const ALIGN_CENTER:String = 'center';
        public static const ALIGN_TOP_LEFT:String = 'top_left';
        public var align:String = ALIGN_CENTER; // center or top_left

        public function GridLayout(container:Sprite, rowCount:uint, columnCount:uint, cellWidth:Number, cellHeight:Number) {
            _container = container;
            _rowCount = rowCount;
            _columnCount = columnCount;
            _cellHeight = cellHeight;
            _cellWidth = cellWidth;
            _cells = [];

            for (var rowIndex:uint = 0; rowIndex < _rowCount; rowIndex++) {
                var r:Array = [];
                for (var columnIndex:uint = 0; columnIndex < _columnCount; columnIndex++) {
                    r.push(new Cell(this, rowIndex, columnIndex));
                }
                _cells.push(r);
            }
        }

        public static function newFromSize(
            container:Sprite, width:Number, height:Number, cellWidth:Number, cellHeight:Number):GridLayout 
        {
            return new GridLayout(
                container,
                Math.floor(width / cellWidth),
                Math.floor(height / cellHeight),
                cellWidth,
                cellHeight
            );
        }

        public function get container():Sprite {
            return _container;
        }

        public function get rowCount():uint {
            return _rowCount;
        }

        public function get columnCount():uint {
            return _columnCount;
        }

        public function get cellHeight():Number {
            return _cellHeight;
        }

        public function get cellWidth():Number {
            return _cellWidth;
        }

        /*
        public function moveTo(r:uint, c:uint, toR:uint, toC:uint, setPosition:Boolean = true):Boolean {
            if (check(r, c) && !check(toR, toC)) {
                var o:DisplayObject = remove(r, c);
                //setObject(toR, toC, o, setPosition);
                return true;
            } else {
                return false;
            }
        }
        */

        public function remove(r:uint, c:uint):DisplayObject {
            var o:DisplayObject = cell(r, c).content;
            _cells[r][c] = null;
            if (o) container.removeChild(o);
            return o;
        }

        public function topLeft(r:uint, c:uint):Cell {
            return getCellIgnoreError(r - 1, c - 1);
        }

        public function top(r:uint, c:uint):Cell {
            return getCellIgnoreError(r, c - 1);
        }

        public function topRight(r:uint, c:uint):Cell {
            return getCellIgnoreError(r + 1, c - 1);
        }

        public function left(r:uint, c:uint):Cell {
            return getCellIgnoreError(r - 1, c);
        }

        public function right(r:uint, c:uint):Cell {
            return getCellIgnoreError(r + 1, c);
        }

        public function bottomLeft(r:uint, c:uint):Cell {
            return getCellIgnoreError(r - 1, c + 1);
        }

        public function bottom(r:uint, c:uint):Cell {
            return getCellIgnoreError(r, c + 1);
        }

        public function bottomRight(r:uint, c:uint):Cell {
            return getCellIgnoreError(r + 1, c + 1);
        }

        public function check(r:uint, c:uint):Boolean {
            if (r > rowCount-1 || c > columnCount-1) 
                throw new LayoutError('Cell [' + [r,c].toString() + '] is over in layout.');
            return !!_cells[r][c];
        }

        public function cell(r:uint, c:uint):Cell {
            return _cells[r][c];
        }

        public function cells(hasDisplayObjectOnly:Boolean = false):Array {
            var res:Array = [];
            for (var r:uint = 0; r < rowCount; r++) {
                res = res.concat(row(r, hasDisplayObjectOnly));
            }
            return res;
        }

        public function getCellIgnoreError(r:uint, c:uint):Cell {
            if (r > rowCount-1 || c > columnCount-1) return null;
            return _cells[r][c];
        }

        public function get width():Number {
            return (_rowCount) * _cellWidth;
        }

        public function get height():Number {
            return (_columnCount) * _cellHeight;
        }

        public function row(r:uint, hasDisplayObjectOnly:Boolean = false):Array {
            if (r > rowCount-1)
                throw new LayoutError('Row [' + r + '] is over in layout.');

            var res:Array = [];
            for (var c:uint = 0; c < columnCount; c++) {
                if (hasDisplayObjectOnly) {
                    if (_cells[r][c].content)
                        res.push(_cells[r][c]);
                } else {
                    res.push(_cells[r][c]);
                }
            }
            return res;
        }

        public function column(c:uint, hasDisplayObjectOnly:Boolean = false):Array {
            if (c > columnCount-1)
                throw new LayoutError('Column [' + c + '] is over in layout.');

            var res:Array = [];
            for (var r:uint = 0; r < rowCount; r++) {
                if (hasDisplayObjectOnly) {
                    if (_cells[r][c].content)
                        res.push(_cells[r][c]);
                } else {
                    res.push(_cells[r][c]);
                }
            }
            return res;
        }

        /*
        public function createObjects(f:Function):void {
            var xPoint:Number;
            var yPoint:Number;
            for (var x:uint = 0; x < _rowCount; x++) {
                xPoint = x * cellWidth;
                for (var y:uint = 0; y < _columnCount; y++) {
                    yPoint = y * cellHeight;
                    setObject(x, y, f.call(null, x, y, xPoint, yPoint), false);
                }
            }
        }
        */

        public function drawLines(setGraphics:Function = null):void {
            var g:Graphics = container.graphics;
            setGraphics ||= function(g:Graphics):void {
                g.lineStyle(0, 0x999999);
            }
            setGraphics(g);

            var xPoint:Number;
            var yPoint:Number;
            for (var x:uint = 0; x <= _rowCount; x++) {
                xPoint = x * cellWidth;
                g.moveTo(xPoint, 0);
                g.lineTo(xPoint, height);
                for (var y:uint = 0; y <= _columnCount; y++) {
                    yPoint = y * cellHeight;
                    g.moveTo(0, yPoint);
                    g.lineTo(width, yPoint);
                }
            }
        }

        public function showPoints(size:Number = 5, setGraphics:Function = null):void {
            var g:Graphics = container.graphics;
            setGraphics ||= function(g:Graphics):void {
                g.lineStyle(0, 0x999999);
            }
            setGraphics(g);

            var xPoint:Number;
            var yPoint:Number;
            for (var x:uint = 0; x < _rowCount; x++) {
                xPoint = (x + (align == ALIGN_CENTER ? 0.5 : 0)) * cellWidth;
                for (var y:uint = 0; y < _columnCount; y++) {
                    yPoint = (y + (align == ALIGN_CENTER ? 0.5 : 0)) * cellHeight;
                    g.moveTo(-size + xPoint, yPoint);
                    g.lineTo(size + xPoint, yPoint);

                    g.moveTo(xPoint, -size + yPoint);
                    g.lineTo(xPoint, size + yPoint);
                }
            }
        }

    }
}
