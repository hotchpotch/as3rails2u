package com.rails2u.chain {
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    public class Chain extends EventDispatcher {
        private var _parent:Chain;
        public var results:*;

        public function Chain() {
        }

        protected var _running:Boolean = false;
        public function get running():Boolean {
            return parent ? parent.running : _running;
        }
        public function set running(r:Boolean):void {
            if (parent) {
                parent.running = r;
            } else {
                _running = r;
            }
        }
        
        public function get parent():Chain {
            return _parent;
        }
        
        public function set parent(__parent:Chain):void {
            _parent = __parent;
            _parent.setChild(this);
        }

        public function get parentsResults():Array {
            var p:Chain = parent;
            var res:Array = [];
            while (p) {
                res.push(p.results);
                p = p.parent;
            }
            return res;
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
            running = true;
            if (parent) {
                return parent.start();
            } else {
                if (running) {
                    execute();
                }
                return this;
            }
        }

        public function stop():Chain {
            running = false;
            return this;
        }

        protected function execute():void {
            finish();
            next();
        }

        protected function next():void {
            //if (child && child.running) child.execute();
            if (child) child.execute();
        }

        protected function finish():void {
            if (!child) _running = false;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        /* shortcut */
        public function parallel(...chains):ParallelChain {
            return chain(new ParallelChain(chains)) as ParallelChain;
        }

        public function eventChain(
            target:IEventDispatcher, 
            executeFunction:Function = null, 
            completeEventName:String = Event.COMPLETE
        ):EventChain {
            return chain(new EventChain(target, executeFunction, completeEventName)) as EventChain;
        }

        public function e(
            target:IEventDispatcher, 
            executeFunction:Function = null, 
            completeEventName:String = Event.COMPLETE
        ):EventChain {
            return chain(new EventChain(target, executeFunction, completeEventName)) as EventChain;
        }

        public function functionChain(executeFunction:Function, callNotify:Boolean = false):FunctionChain {
            return chain(new FunctionChain(executeFunction, callNotify)) as FunctionChain;
        }

        public function f(executeFunction:Function, callNotify:Boolean = false):FunctionChain {
            return chain(new FunctionChain(executeFunction, callNotify)) as FunctionChain;
        }

        public function loop(times:uint = 0):LoopChain {
            return chain(new LoopChain(times)) as LoopChain;
        }

        public function delay(msec:uint):DelayChain {
            return chain(new DelayChain(msec)) as DelayChain;
        }
    }
}
