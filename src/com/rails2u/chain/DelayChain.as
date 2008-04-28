package com.rails2u.chain {
    import flash.events.Event;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class DelayChain extends EventChain {
        public function DelayChain(delay:uint) {
            super(new Timer(delay, 1), function(c:Chain, t:Timer):void {
               t.start(); 
            }, TimerEvent.TIMER_COMPLETE);
        }

    }
}
