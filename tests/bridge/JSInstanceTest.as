package {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import com.rails2u.bridge.JSInstance;
    import com.rails2u.bridge.JSProxy;
    import com.rails2u.utils.JSUtil;
    import flash.events.Event;

    [SWF(frameRate=60, background=0x000000)]
    public class JSInstanceTest extends Sprite {
        public function JSInstanceTest() {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            init();
        }

        public var ins:JSInstance;
        public function init():void {
            log('load');
            ins = JSInstance.getInstance();
            ins.value = '1';
            ins.funcTest = function():void {
                log('call func test');
            };
            ins.log = log;

            ins.loadComplete();
            log('dispatch');
            ins.dispatchEvent(new Event('test'));
        }
    }
}
