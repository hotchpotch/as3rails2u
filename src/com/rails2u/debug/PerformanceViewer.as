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
        public var lastTime:uint;
        
        public function PerformanceViewer(color:uint = 0xFFFFFF) {
            super();
            
            visible = false;
            width = 150;
            height = 40;
            background = true;
            backgroundColor = 0x000000;
            
            var format:TextFormat = new TextFormat();
            format.color = color;
            format.size = 12;
            format.bold = true;
            format.font = 'Arial';
            defaultTextFormat = format;
            
            lastTime = getTimer();
            addEventListener(Event.ENTER_FRAME, refresh);
        }
        
        private function refresh(event:Event):void {
             var time:int = getTimer();
             text = String(1000 / (time - lastTime)).substring(0, 6) + ' fps' + "\n" +  Number(System.totalMemory) / 1000 + " KB";
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
