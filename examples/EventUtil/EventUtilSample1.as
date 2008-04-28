package {
    import com.rails2u.utils.EventUtil;
    import com.rails2u.utils.ColorUtil;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    [SWF(backgroundColor=0xFFFFFF)]
    public class EventUtilSample1 extends Sprite {
        private var color:uint = 0;
        public function EventUtilSample1() {
            var loader:URLLoader = new URLLoader();
            // auto attach event onHttpStatus onOpen onComplete
            EventUtil.bindEventHandler(loader, this);

            // auto attach event onMouseDown, onMouseUp, onKeyDown
            EventUtil.bindEventHandlerByEvent(this.stage, this, [MouseEvent, KeyboardEvent]);
            // auto attach event onEnterFrame
            EventUtil.bindEventHandlerByEvent(this, null, Event);

            EventUtil.aggregateEventHandler(loader, logHandler, [IOErrorEvent.IO_ERROR, SecurityErrorEvent.SECURITY_ERROR]);
            // or
           // EventUtil.addGenericErrorHandler(loader, logHandler);

            // load success
            loader.load(new URLRequest('http://webservices.amazon.co.jp/crossdomain.xml'));
            // security error
            loader.load(new URLRequest('http://www.hatena.ne.jp/'));
            // io error
            loader.load(new URLRequest('http://webservices.amazon.co.jp/file/not/found'));
        }

        private var sizeX:uint = 10;
        private var sizeY:uint = 10;
        public function onEnterFrame(e:Event):void {
            graphics.clear();
            graphics.beginFill(color);
            graphics.drawRect(100,100,sizeX,sizeY);

            if (sizeX > 300) return; // Bad
            sizeX++;
            sizeY++;
        }

        public function onMouseDown(e:MouseEvent):void {
            log('click!(color change)');
            color = ColorUtil.random();
        }

        public function onMouseUp(e:MouseEvent):void {
            log('mouse up!');
        }

        public function onKeyDown(e:Event):void {
            log('keydown');
        }

        public function onHttpStatus(e:HTTPStatusEvent):void {
            log('http status:' + e.status);
        }

        public function onOpen(e:Event):void {
            log('open url');
        }

        public function onComplete(e:Event):void {
            log('load data:', e.target.data);
        }

        public function logHandler(e:Event):void {
            log('log:', e);
        }
    }
}
