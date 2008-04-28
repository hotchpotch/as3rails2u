package com.rails2u.record {
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class RecordPlayer extends Timer {
        protected var records:Array;
        protected var originalRecords:Array;

        public function RecordPlayer(records:Array) {
            super(10, 0);
            setRecords(records);
            addEventListener(TimerEvent.TIMER, timerHander);
        }

        public function setRecords(records:Array):void {
            /*
            var ba:ByteArray = ByteArray(records);
            ba.uncompress();
            ba.position = 0;
            this.records = ba.readObject();
            */
            this.records = records.splice(0);
            originalRecords = this.records.slice(0);
        }

        public override function start():void {
            super.start();
            dispatchEvent(new RecordEvent(RecordEvent.START));
        }

        public function get totalTime():uint {
            return records[records.length-1][0];
        }

        public override function stop():void {
            super.stop();
            dispatchEvent(new RecordEvent(RecordEvent.STOP));
        }

        public function pause():void {
            // ToDo
        }

        public function forceFinish():void {
            while(records.length > 0) {
                sendEvent();
            }
            dispatchEvent(new RecordEvent(RecordEvent.FINISH));
            stop();
        }

        public var playSpeed:Number = 1;
        protected var playStart:uint;
        protected function timerHander(e:Event):void {
            playStart ||= getTimer();
            var now:uint = getTimer() * playSpeed;

            while(records.length > 0 && (records[0][0] <= (now - playStart))) {
                sendEvent();
            }
            if (records.length == 0) {
                stop();
                dispatchEvent(new RecordEvent(RecordEvent.FINISH));
            }
        }

        protected function sendEvent():void {
            var record:Array = records.shift();
            // record = [currentTime, args]
            dispatchEvent(new RecordEvent(RecordEvent.EVENT, false, false, record[1]));
        }
    }
}
