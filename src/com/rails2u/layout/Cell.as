package com.rails2u.layout {
    import flash.events.EventDispatcher;
    import flash.display.DisplayObject;

    public class Cell {
        protected var _rowIndex:uint;
        protected var _columnIndex:uint;
        protected var _layout:GridLayout;
        public var data:Object;

        public function Cell(layout:GridLayout, rowIndex:uint, columnIndex:uint) {
            this._layout = layout;
            this._rowIndex = rowIndex;
            this._columnIndex = columnIndex;
        }

        protected var _content:DisplayObject;
        public function get content():DisplayObject {
            return _content;
        }

        public function set content(o:DisplayObject):void {
            _layout.container.addChild(o);
            o.x = xValue;
            o.y = yValue;
            _content = o;
        }

        public function get xValue():Number {
            if (_layout.align == GridLayout.ALIGN_CENTER) {
                return (rowIndex + 0.5) * width;
            //} else if (_layout.align == GridLayout.ALIGN_TOP_LEFT) {
            } else {
                return rowIndex * width;
            }
        }

        public function get yValue():Number {
            if (_layout.align == GridLayout.ALIGN_CENTER) {
                return (columnIndex + 0.5) * height;
            //} else if (_layout.align == GridLayout.ALIGN_TOP_LEFT) {
            } else {
                return columnIndex * height;
            }
        }

        public function get width():Number {
            return _layout.cellWidth;
        }

        public function get height():Number {
            return _layout.cellHeight;
        }

        public function get topLeft():Cell {
            return _layout.topLeft(rowIndex, columnIndex);
        }

        public function get top():Cell {
            return _layout.top(rowIndex, columnIndex);
        }

        public function get topRight():Cell {
            return _layout.topRight(rowIndex, columnIndex);
        }

        public function get left():Cell {
            return _layout.left(rowIndex, columnIndex);
        }

        public function get right():Cell {
            return _layout.right(rowIndex, columnIndex);
        }

        public function get bottomLeft():Cell {
            return _layout.bottomLeft(rowIndex, columnIndex);
        }

        public function get bottom():Cell {
            return _layout.bottom(rowIndex, columnIndex);
        }

        public function get bottomRight():Cell {
            return _layout.bottomRight(rowIndex, columnIndex);
        }

        public function get layout():GridLayout {
            return _layout;
        }

        public function set layout(o:GridLayout):void {
            _layout = o;
        }

        public function get rowIndex():Number {
            return _rowIndex;
        }

        public function get columnIndex():Number {
            return _columnIndex;
        }

        public function toString():String {
            return 'Cell: [' + rowIndex + ', ' + columnIndex + ']';
        }
    }
}
