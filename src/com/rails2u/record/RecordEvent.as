package com.rails2u.record {
    import flash.events.Event;

    public class RecordEvent extends Event {
        public static const PLAY:String = 'start';
        public static const STOP:String = 'stop';
        public static const PAUSE:String = 'pause';
        public static const FINISH:String = 'finish';

        public function RecordEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void {
            super(type, bubbles, cancelable);
        }
    }
}
