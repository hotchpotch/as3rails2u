package com.rails2u.record {
    import flash.display.InteractiveObject;
    import flash.events.MouseEvent;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

    public class MouseRecorder {
        public static const MOUSE_EVENT_NAMES:Array = [
           MouseEvent.MOUSE_DOWN,
           MouseEvent.MOUSE_MOVE,
           MouseEvent.MOUSE_UP,
           MouseEvent.MOUSE_OUT,
           MouseEvent.MOUSE_OVER,
           MouseEvent.MOUSE_WHEEL,
           MouseEvent.ROLL_OVER,
           MouseEvent.ROLL_OUT
        ];

        public var priority:int = -1;
        public var useWeakReference:Boolean = false;

        protected var _canvas:InteractiveObject;
        protected var _eventNames:Array = [];
        public function MouseRecorder(canvas:InteractiveObject) {
            _canvas = canvas;
            eventNames = MOUSE_EVENT_NAMES.splice(0);
        }

        protected var _started:Boolean = false;
        public function get started():Boolean {
            return _started;
        }
        
        protected var _recordTypes:Dictionary;
        public function get recordTypess():Dictionary{
            return _recordTypes;
        }

        public static const BUBBLES_TRUE:uint = 1;
        public static const BUBBLES_FALSE:uint = 2;
        public static const BUBBLES_BOTH:uint = 0;
        protected var _recordBubblesType:uint = BUBBLES_TRUE;

        public function set recordBubblesType(u:uint):void {
            _recordBubblesType = u;
        }

        public function get recordBubblesType():uint {
            return _recordBubblesType;
        }

        public function get eventNames():Array {
            return _eventNames;
        }

        public function set eventNames(n:Array):void {
            _recordTypes = new Dictionary();
            for each(var evName:String in n) {
                _recordTypes[evName] = true;
            }
            _eventNames = n;
        }

        public function recordOn(name:String):Boolean {
            if (_recordTypes.hasOwnProperty(name)) {
                _recordTypes[name] = true;
                return true;
            }
            return false;
        }

        public function recordOff(name:String):Boolean {
            if (_recordTypes.hasOwnProperty(name)) {
                _recordTypes[name] = false;
                return true;
            }
            return false;
        }

        public function start():Boolean {
            if (_started) {
                return false;
            } else {
                addHandlers(_canvas, eventNames);
                _started = true;
                return true;
            }
        }

        public function stop():Boolean {
            if (started) {
                _started = false;
                removeHandlers(_canvas, eventNames);
                return true;
            } else {
                return false;
            }
        }

        protected function addHandlers(t:IEventDispatcher, ens:Array):void {
            for each(var evName:String in ens) {
                t.addEventListener(evName, recordHandler, false, priority, useWeakReference);
                t.addEventListener(evName, recordHandler, true, priority, useWeakReference);
            }
        }

        protected function removeHandlers(t:IEventDispatcher, ens:Array):void { 
            for each(var evName:String in ens) {
                t.removeEventListener(evName, recordHandler, false);
                t.removeEventListener(evName, recordHandler, true);
            }
        }

        protected function recordHandler(e:MouseEvent):void {
            if (!_recordTypes[e.type] || 
                (
                recordBubblesType != BUBBLES_BOTH && 
                (e.bubbles == true ? BUBBLES_TRUE : BUBBLES_FALSE) != recordBubblesType
                )
            ) return;
        }
    }
}
