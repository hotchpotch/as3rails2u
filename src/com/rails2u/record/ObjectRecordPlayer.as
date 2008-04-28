package com.rails2u.record {
    import flash.utils.ByteArray;

    public class ObjectRecordPlayer extends RecordPlayer {
        public var targetObject:Object;

        public function ObjectRecordPlayer(records:Array, targetObject:Object) {
            super(records);
            this.targetObject = targetObject;
            addEventListener(RecordEvent.EVENT, methodDispatchHandler);
        }

        protected function methodDispatchHandler(e:RecordEvent):void {
            var record:Array = e.record.slice(0);
            var methodName:String = record.splice(0, 1);
            targetObject[methodName].apply(targetObject, record);
        }
    }
}
