package com.rails2u.chain {
    import flash.events.EventDispatcher;
    import flash.events.Event;
    public class FunctionChain extends Chain {
        protected var executeFunction:Function;
        public var callNotify:Boolean;
        public function FunctionChain(executeFunction:Function, callNotify:Boolean = false):void {
            super();
            this.callNotify = callNotify;
            this.executeFunction = executeFunction;
        }

        protected override function execute():void {
            executeFunction.call(null, this);
            if (!callNotify) notify();
        }

        public function notify():void {
            finish();
            next();
        }

        /*
        public function get completeNotifier():Function {
            var self:FunctionChain = this;
            return function():void {
                self.notify();
            };
        }
        */
    }
}


