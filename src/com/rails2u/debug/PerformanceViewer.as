package rails2u.debug {
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.display.DisplayObjectContainer;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    import flash.system.System;

    /* 
      * don't use this class!
      */
    public class PerformanceViewer {
        private var _stage:DisplayObjectContainer;
        public var viewer:TextField;
        public var toggleKeybind:String = 'v';

        public function PerformanceViewer(__stage:DisplayObjectContainer) {
            _stage = __stage;

            initViewer();

            var lastTime:int = getTimer();
            _stage.addEventListener(Event.ENTER_FRAME, function(event:Event):void {
                    var time:int = getTimer();
                    viewer.text = int(1000 / (time - lastTime)) + ' fps' + "\n" +  Number(System.totalMemory) / 1000 + " KB";
                    lastTime = time;
            });
            _stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, toggleHandler);
        }

        private function initViewer():void {
            viewer = new TextField();
            viewer.visible = false;
            viewer.width = 300;
            var format:TextFormat = new TextFormat();
            format.color = 0xFFFFFF;
            format.size = 28;
            format.bold = true;
            format.font = 'Arial';
            viewer.defaultTextFormat = format;
            _stage.addChild(viewer);
        }

        public function show():void {
            viewer.visible = true;
        }

        public function hide():void {
            viewer.visible = false;
        }

        public function toggle():void {
            viewer.visible ? viewer.visible = false : viewer.visible = true;
        }

        private function toggleHandler(event:KeyboardEvent):void {
            if (toggleKeybind) {
                if (toggleKeybind.charCodeAt(0) == event.charCode) {
                    toggle();
                }
            }
        }
    }
}
