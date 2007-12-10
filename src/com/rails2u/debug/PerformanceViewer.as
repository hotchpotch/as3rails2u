package com.rails2u.debug {
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    import flash.system.System;
    import flash.utils.Timer;

    /**
    * PerformanceViewer
    * 
    * PerformanceViewer show FPS, used memory size.
    * 
    * example:
    * <listing version="3.0">
    *   var pv:PerformanceViewer = new PerformanceViewer;
    *   stage.addChild(pv);
    *   pv.show();
    *   pv.hide();
    *   pv.toggle();
    * </listing>
    */
    public class PerformanceViewer extends TextField {
        private var lastTime:uint;
        private var _fps:Number = 60;
        public function get fps():Number {
            return _fps;
        }
        
        private var timer:Timer;
        public function PerformanceViewer(color:uint = 0xFFFFFF, delay:Number = 200) {
            super();
            
            visible = false;
            width = 150;
            height = 40;
            background = false;
            backgroundColor = 0x555555;
            
            var format:TextFormat = new TextFormat();
            format.color = color;
            format.size = 12;
            format.bold = true;
            format.font = 'Arial';
            defaultTextFormat = format;
            
            lastTime = getTimer();

            timer = new Timer(delay);
            timer.addEventListener('timer', render);
            timer.start();
            addEventListener(Event.ENTER_FRAME, countHandler);
        }
        
        private var _fpss:Array = [];
        private function countHandler(e:Event):void {
             var time:int = getTimer();
             _fpss.push(time - lastTime);
             lastTime = time;
        }

        private function render(e:Event):void {
            _fps = 0;
            for each(var v:Number in _fpss) {
                _fps += v;
            }
            _fps /= _fpss.length;
            var rCount:int = _fpss.length;
            _fpss = [];
            text = String(1000 / (_fps)).substring(0, 6) + ' FPS' + "\n" +  Number(System.totalMemory) / 1000 + " KB";
        }

        private function init():void {
        }

        public function show():void {
            visible = true;
        }

        public function hide():void {
            visible = false;
        }

        public function toggle():void {
            visible ? visible = false : visible = true;
        }
    }
}
