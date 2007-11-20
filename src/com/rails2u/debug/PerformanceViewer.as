package com.rails2u.debug {
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    import flash.system.System;

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
        private var lastTimeSecond:uint;
        
        public function PerformanceViewer(color:uint = 0xFFFFFF) {
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
            lastTimeSecond = lastTime;
            addEventListener(Event.ENTER_FRAME, refresh);
        }
        
        private var _fpss:Array = [];
        private function refresh(event:Event):void {
             var time:int = getTimer();
             if (time - lastTimeSecond > 200) {
                  var _fps:Number = 0;
                  _fpss.forEach(function(v:Number, ... args):void { _fps += v });
                  _fps /= _fpss.length;
                  _fpss = [];
                  text = String(1000 / (_fps)).substring(0, 6) + ' FPS' + "\n" +  Number(System.totalMemory) / 1000 + " KB";
                  lastTimeSecond = time;
             } else {
                 _fpss.push(time - lastTime);
             }
             lastTime = time;
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
