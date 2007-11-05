package com.rails2u.core {
    public class Enumerator {
        internal var iNext:Function;
        internal var iHasNext:Function;
        internal var iCount:Function;
        internal var index:uint = 0;
        internal var _ary:Array;

        public function Enumerator(
            _ary:Array = null, 
            iNext:Function = null, 
            iHasNext:Function = null, 
            iCount:Function = null
        ) {
            if (_ary)
                this._ary = _ary.splice(0);
            if (iNext)
                this.iNext = iNext;
            if (iHasNext)
                this.iHasNext = iHasNext;
            if (iCount)
                this.iCount = iCount;
        }

        public function rewind():void {
            index = 0;
        }

        public function get length():Number {
            if (iCount is Function) {
                return iCount(this);
            } else {
                return _ary.length;
            }
        }

        public function get count():Number {
            return length;
        }

        public function each(f:Function):void {
            var iTemp:uint = index;
            index = 0;
            try {
                while(hasNext()) f(next());
            } finally {
                index = iTemp;
            }
        }

        public function next():* {
            if (!hasNext()) {
                throw new StopIteration('StopIteration');
            }
            if (iNext is Function) {
                return iNext(this);
            } else {
                return _ary[index++];
            }
        }

        public function hasNext():Boolean {
            if (iHasNext is Function) {
                return iHasNext(this);
            } else {
                return _ary.length > index;
            }
        }

        public function to_a():Array {
            var iTemp:uint = index;
            index = 0;
            var res:Array = [];
            while(hasNext()) {
                res.push(next());
            }
            index = iTemp;
            return res;
        }

    //rb_define_method(rb_mKernel, "to_enum", obj_to_enum, -1);
    //rb_define_method(rb_mKernel, "enum_for", obj_to_enum, -1);

    //rb_define_method(rb_mEnumerable, "each_slice", enum_each_slice, 1);
    //rb_define_method(rb_mEnumerable, "each_cons", enum_each_cons, 1);

    //rb_cEnumerator = rb_define_class_under(rb_mEnumerable, "Enumerator", rb_cObject);
    //rb_include_module(rb_cEnumerator, rb_mEnumerable);

    //rb_define_alloc_func(rb_cEnumerator, enumerator_allocate);
    //rb_define_method(rb_cEnumerator, "initialize", enumerator_initialize, -1);
    //rb_define_method(rb_cEnumerator, "initialize_copy", enumerator_init_copy, 1);
    //rb_define_method(rb_cEnumerator, "each", enumerator_each, 0);
    //rb_define_method(rb_cEnumerator, "with_index", enumerator_with_index, 0);
    //rb_define_method(rb_cEnumerator, "to_splat", enumerator_to_splat, 0);
    //rb_define_method(rb_cEnumerator, "next", enumerator_next, 0);
    //rb_define_method(rb_cEnumerator, "rewind", enumerator_rewind, 0);
    }
}
