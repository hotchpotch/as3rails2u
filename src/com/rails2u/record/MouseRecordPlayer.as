package com.rails2u.record {
    import flash.display.InteractiveObject;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.events.MouseEvent;
    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;

    public class MouseRecordPlayer extends EventDispatcher {
        protected var _canvas:InteractiveObject;
        protected var records:Array;
        protected var originalRecords:Array;
        public function MouseRecordPlayer(canvas:InteractiveObject) {
            _canvas = canvas;
        }

        public function setRecords(records:ByteArray):void {
            var ba:ByteArray = ByteArray(records);
            ba.uncompress();
            ba.position = 0;
            this.records = ba.readObject();
            originalRecords = this.records.slice(0);
        }

        protected var _playing:Boolean = false;
        public function get playing():Boolean {
            return _playing;
        }

        public function play():Boolean {
            if (playing) return false;

            _playing = true;
            _canvas.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            dispatchEvent(new RecordEvent(RecordEvent.PLAY));
            return true;
        }

        public function stop():Boolean {
            if (!playing) return false;
            _playing = false;
            _canvas.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            dispatchEvent(new RecordEvent(RecordEvent.STOP));
            return true;
        }

        public function pause():void {
            // ToDo
        }

        public function forceFinish():void {
            while(records.length > 0) {
                var cur:Array = records.shift();
                var ev:MouseEvent = objectToMouseEvent(cur[1]);
                var t:InteractiveObject = InteractiveObject(DisplayObjectContainer(_canvas).getChildByName(cur[1].name)) || _canvas;
                t.dispatchEvent(ev);
            }
            dispatchEvent(new RecordEvent(RecordEvent.FINISH));
        }

        protected var playStart:uint;
        protected function enterFrameHandler(e:Event):void {
            playStart ||= getTimer();
            var now:uint = getTimer();

            while(records.length > 0 && (records[0][0] <= (now - playStart))) {
                var cur:Array = records.shift();
                var ev:MouseEvent = objectToMouseEvent(cur[1]);
                //log(ev.type, ev);
                //var t:InteractiveObject = (typeObject(cur[2]) as InteractiveObject);
                //if(t) t.dispatchEvent(ev);
                //log(cur[1].name);
                var t:InteractiveObject = InteractiveObject(DisplayObjectContainer(_canvas).getChildByName(cur[1].name)) || _canvas;
                t.dispatchEvent(ev);
            }
            if (records.length == 0) 
                dispatchEvent(new RecordEvent(RecordEvent.FINISH));
        }

        private function objectToMouseEvent(o:Object):MouseEvent {
            var e:MouseEvent = new MouseEvent(o.type, true, false, o.localX, o.localY,
            o.relatedObject, o.ctrlKey, o.altKey, o.shiftKey, o.buttonDown, o.delta 
            );
            /*
            delete o['type'];
            delete o['name'];
            delete o['target'];
            delete o['relatedObject'];

            for (var key:String in o) {
                if (o[key] !== null)
                e[key] = o[key];
            }
            */
            return e;
        }
    }
}
