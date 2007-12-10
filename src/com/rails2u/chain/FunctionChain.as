package com.rails2u.chain {
    import flash.events.EventDispatcher;
    import flash.events.Event;
    public class FunctionChain extends Chain {
        protected var executeFunction:Function;
        public function FunctionChain(executeFunction:Function):void {
            super();
            this.executeFunction = executeFunction;
        }

        protected override function execute():void {
            executeFunction.call(this, this);
        }

        public function get completeNotifier():Function {
            var self:FunctionChain = this;
            return function():void {
                self.finish();
                self.next();
            };
        }
    }
}


