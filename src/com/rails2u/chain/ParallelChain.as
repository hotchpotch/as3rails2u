package com.rails2u.chain {
    import flash.events.Event;
    public class ParallelChain extends Chain {
        /*
         * 実装は Chain#addCallback を追加してやるべき？
         * この実装では一階層目のチェインだけで終わってしまう？
         */
        protected var _chainCounter:uint = 0;
        protected var _chains:Array = [];

        public function addParallelChain(c:Chain):ParallelChain {
            c.addEventListener(Event.COMPLETE, completeHandler);
            _chains.push(c);
            return this;
        }

        public function addParallelChains(args:Array):ParallelChain {
            for each(var c:Chain in args) {
                addParallelChain(c);
            }
            return this;
        }

        protected override function execute():void {
            for each(var c:Chain in _chains) {
                c.start();
            }
        }

        protected function completeHandler(e:Event):void {
            e.target.removeEventListener(Event.COMPLETE, completeHandler);
            _chainCounter++;
            if (_chains.length <= _chainCounter) {
                finish();
                next();
            }
        }
    }
}

