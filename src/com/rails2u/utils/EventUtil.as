package com.rails2u.utils {
    import Class;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.getDefinitionByName;

    public class EventUtil {
        private static const EVENT_LISTENER_OPTIONS:Object = {
            useCapture: false,
            priority: 0,
            useWeakReference: false
        };
        private static const GENERIC_ERROR_EVENT_STRINGS:Array = [
           'securityError', 'error', 'asyncError', 'ioError'
        ];

        public static function bindEventHandlerByEvent(
            target:EventDispatcher, currentTarget:Object = null, events:* = null, 
            prefix:String = 'on', eventListenerOptions:Object = null
        ):void {
            currentTarget ||= target;
            eventListenerOptions ||= EVENT_LISTENER_OPTIONS;

            if(!(events is Array)) events = [events];
            for each(var event:Class in events) {
                var r:Reflection = Reflection.factory(event);
                for (var eventName:String in r.constantsTable) {
                    utilAddEventListener(target, currentTarget, eventName, prefix, eventListenerOptions);
                }
            }
        }

        public static function bindEventHandler(
            target:EventDispatcher, currentTarget:Object = null,
            prefix:String = 'on', eventListenerOptions:Object = null
        ):void {
            currentTarget ||= target;
            eventListenerOptions ||= EVENT_LISTENER_OPTIONS;

            for each (var eventName:String in 
                    Reflection.factory(String(Reflection.factory(target).type.@name)).type.metadata.arg.(@key == 'name').@value
            ) {
                utilAddEventListener(target, currentTarget, eventName, prefix, eventListenerOptions);
            }
            return;

        }

        public static function aggregateEventHandler(
            target:EventDispatcher, method:Function, 
            eventNames:*, eventListenerOptions:Object = null
        ):void {
            eventListenerOptions ||= EVENT_LISTENER_OPTIONS;
            if(!(eventNames is Array)) eventNames = [eventNames];
            for each (var eventName:String in eventNames) {
                target.addEventListener(eventName, method,
                    eventListenerOptions.useCapture, eventListenerOptions.priority, eventListenerOptions.useWeakReference
                );
            }
        }

        public static function addGenericErrorHandler(
            target:EventDispatcher, method:Function, eventListenerOptions:Object = null
        ):void {
            eventListenerOptions ||= EVENT_LISTENER_OPTIONS;
            for each (var eventName:String in GENERIC_ERROR_EVENT_STRINGS) {
                target.addEventListener(eventName, method,
                    eventListenerOptions.useCapture, eventListenerOptions.priority, eventListenerOptions.useWeakReference
                );
            }
        }

        protected static function utilAddEventListener(
          target:EventDispatcher, currentTarget:Object, eventName:String, 
          prefix:String, eventListenerOptions:Object
        ):void {
            var targetRefrection:Reflection = Reflection.factory(currentTarget);
            var className:String = String(targetRefrection.type.@name);

            var handlerName:String = prefix + StringUtil.camelize(eventName);
            var eventClassName:String = String(targetRefrection.type.method.(
                @name == handlerName && @declaredBy == className
            ).parameter.@type);
            if (eventClassName == '') return;

            // var eventClass:Class = Class(getDefinitionByName(eventClassName));
            // log(target, eventName, currentTarget, handlerName);
            target.addEventListener(
                    eventName, currentTarget[handlerName],
                    eventListenerOptions.useCapture, eventListenerOptions.priority, eventListenerOptions.useWeakReference
            );
        }
    }
}
