package com.rails2u.chain {
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    public class EventChain extends Chain {
        protected var target:IEventDispatcher;
        protected var executeFunction:Function;
        protected var completeEventName:String;

        public function EventChain(target:IEventDispatcher, executeFunction:Function = null, completeEventName:String = Event.COMPLETE) {
            super();
            this.target = target;
            this.executeFunction = executeFunction as Function;
            this.completeEventName = completeEventName;
        }

        protected override function execute():void {
            target.addEventListener(completeEventName, completeHandler);
            executeFunction.call(target);
        }

        protected function completeHandler(e:Event):void {
            target.removeEventListener(completeEventName, completeHandler);
            finish();
            next();
        }
    }
}

