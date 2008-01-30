package com.rails2u.record {
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    public class Recorder {
        protected var records:Array = [];

        public function Recorder() {
        }

        protected var _started:Boolean = false;
        public function get started():Boolean {
            return _started;
        }

        public function start():Boolean {
            if (_started) {
                return false;
            } else {
                _started = true;
                return true;
            }
        }
        
        public function stop():Boolean {
            if (started) {
                _started = false;
                return true;
            } else {
                return false;
            }
        }

        protected var _startRecordTime:uint;
        public function get startRecordTime():uint {
            return _startRecordTime;
        }

        public function addRecord(...args):void {
            _startRecordTime ||= getTimer();
            records.push([getTimer() - startRecordTime, args]);
        }

        public function getRecords():Array {
            return records.slice(0);
        }

        public function getRecordsByteArra():ByteArray {
            var b:ByteArray = new ByteArray;
            b.writeObject(records);
            b.position = 0;
            b.compress();
            return b;
        }

    }
}
