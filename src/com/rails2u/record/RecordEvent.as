package com.rails2u.record {
    import flash.events.Event;

    public class RecordEvent extends Event {
        public static const START:String = 'start';
        public static const PLAY:String = 'play';
        public static const STOP:String = 'stop';
        public static const PAUSE:String = 'pause';
        public static const FINISH:String = 'finish';

        public static const EVENT:String = 'event';

        public function RecordEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, record:Array = null):void {
            super(type, bubbles, cancelable);

            if (record)
                 this.record = record;
        }
        public var record:Array;
    }
}
