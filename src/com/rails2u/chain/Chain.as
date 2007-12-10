package com.rails2u.chain {
    import flash.events.EventDispatcher;
    import flash.events.Event;
    public class Chain extends EventDispatcher {
        /* 
         * ToDo
         * ErrorBack
         */

        private var _parent:Chain;
        public function get parent():Chain {
            return _parent;
        }
        
        public function set parent(__parent:Chain):void {
            _parent = __parent;
            _parent.setChild(this);
        }

        protected var child:Chain;
        public function setChild(child:Chain):void {
            this.child = child;
        }
        

        public function chain(_chain:Chain):Chain {
            _chain.parent = this;
            return _chain;
        }

        public function start():Chain {
            if (parent) {
                return parent.start();
            } else {
                execute();
                return this;
            }
        }

        protected function execute():void {
            finish();
            next();
        }

        protected function next():void {
            if (child) child.execute();
        }

        protected function finish():void {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        //public function hasNext():Boolean {
        //    return _chains.length > _chainCounter;
        //}
    }
}
