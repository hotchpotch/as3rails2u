package {
    import flash.display.Sprite;
    import flash.display.Graphics;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import com.rails2u.debug.DebugWatcher;

    public class MonitorEvents extends Sprite {
        public function MonitorEvents() {
            DebugWatcher.monitorEvents(stage);
            // stage.addEventListener(MouseEvent.MOUSE_DOWN, m);
        }

        private function m(e:MouseEvent):void {
            log(e);
        }
    }
}
