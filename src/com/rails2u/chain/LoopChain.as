package com.rails2u.chain {
    import flash.events.Event;
    import flash.utils.setTimeout;

    public class LoopChain extends DelayChain {
        public var repeatTimes:uint;
        private var _currentTimes:uint = 0;
        public function get currentTimes():uint {
            return _currentTimes;
        }
        
        public function LoopChain(times:uint = 0) {
            repeatTimes = times;
            super(0); // for async
        }

        /*
        public override function stop():Chain {
            super.stop();
            finish();
            return this;
        }
        */

        protected override function completeHandler(e:Event):void {
            target.removeEventListener(completeEventName, completeHandler);
            if (!running) return;

            _currentTimes++;
            if (repeatTimes == 0 || currentTimes < repeatTimes) {
                start();
            } else {
                finish();
                next();
            }
        }
    }
}
