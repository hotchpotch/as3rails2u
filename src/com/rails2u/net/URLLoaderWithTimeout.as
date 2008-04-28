package com.rails2u.net
{
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    /*
     * URLLoader with Timeout
     * loader.addEventListener(IOErrorEvent.IO_ERROR, 
     *    function(e:*):void { trace('timeout!') });
     * loader.loadWithTimeout(request, 30);
     */
    public class URLLoaderWithTimeout extends URLLoader
    {
        public function URLLoaderWithTimeout(request:URLRequest=null)
        {
            super(request);
        }
        
        public function loadWithTimeout(request:URLRequest, timeout:Number = 30):void
        {
            addEventListener(Event.COMPLETE, cancelTimeoutError, false, 1, true);
            observeTimeout(timeout);
            load(request);
        }
        
        private var observeTimer:Timer;
        private function observeTimeout(sec:Number):void
        {
            observeTimer = new Timer(sec * 1000, 1);
            observeTimer.addEventListener(
               TimerEvent.TIMER, timeoutError, false, 1, true
            );
            observeTimer.start();
        }
        
        private function cancelTimeoutError(e:Event):void
        {
            if (observeTimer) {
                observeTimer.removeEventListener(TimerEvent.TIMER, timeoutError);
            }
        }
        
        private function timeoutError(e:TimerEvent):void 
        {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, 'request timeout'));
            observeTimer = null;
        }
    }
}
