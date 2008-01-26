package com.rails2u.chain {
    import flash.events.Event;
    import flash.utils.Dictionary;
    public class ParallelChain extends Chain {
        protected var finishedChains:Array = [];
        protected var _chains:Array = [];

        public function ParallelChain(chains:Array = null) {
            if (chains) addParallelChains(chains);
        }

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
            // e.target.removeEventListener(Event.COMPLETE, completeHandler);
            if (finishedChains.indexOf(e.target) == -1)
                finishedChains.push(Chain(e.target));

            results = getSortedResults();
            if (_chains.length <= finishedChains.length) {
                finish();
                next();
            }
        }

        protected function getSortedResults():Array {
            var res:Array = [];
            for each(var c:Chain in _chains) {
                if (finishedChains.indexOf(c) != -1) res.push(c.results);
            }
            return res;
        }
    }
}

