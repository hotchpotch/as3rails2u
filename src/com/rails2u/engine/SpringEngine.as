package com.rails2u.engine {
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;

    public class SpringEngine extends EventDispatcher {
        protected var _springs:Array;
        public var target:Sprite;
        public var vSpring:Number = 0.1;
        public var friction:Number = 0.95;
        public var drawLine:Boolean = true;
        public var defaultNodeLength:Number;
        public var setGraphics:Function = function(g:Graphics):void {
                g.lineStyle(0.9,0xEEEEEE);
        };
        public var surface:Rectangle;

        public function SpringEngine(target:Sprite) {
            this.target = target;
            _springs = [];
        }

        public function get springs():Array {
            return _springs;
        }

        public function addSpring(spring:Spring):void {
            if (hasSpring(spring)) 
                return;
            target.addChild(spring.target);
            if (isNaN(spring.defaultNodeLength) && !isNaN(defaultNodeLength)) {
                spring.defaultNodeLength = defaultNodeLength;
            }
            _springs.push(spring);
            dispatchEvent(new Event(Event.ADDED));
        }

        public function removeSpring(spring:Spring):void {
            if (!hasSpring(spring)) 
                return;
            target.removeChild(spring.target);
            _springs.splice(_springs.indexOf(spring), 1);
            dispatchEvent(new Event(Event.REMOVED));
        }

        public function hasSpring(spring:Spring):Boolean {
            return _springs.indexOf(spring) == -1 ? false : true;
        }

        public function addDisplayObject(d:DisplayObject):Spring {
            for each(var s:Spring in _springs) {
                if (s.target == d) return s;
            }
            var spring:Spring = new Spring(d);
            addSpring(spring);
            return spring;
        }

        public function start():void {
            target.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        public function stop():void {
            target.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        public function get graphics():Graphics {
            return target.graphics;
        }

        protected function mouseUpHandler(e:MouseEvent):void {
            e.target.stopDrag();
        }

        protected function setVelocity(spring:Spring, node:Spring):void {
            var dx:Number, dy:Number, nodeLen:Number;
            if (spring.getNodeLength(node)) {
                dx = spring.x - node.x;
                dy = spring.y - node.y;
                nodeLen = spring.getNodeLength(node);
                var angle:Number = Math.atan2(dy, dx);
                var targetX:Number = node.x + Math.cos(angle) * nodeLen;
                var targetY:Number = node.y + Math.sin(angle) * nodeLen;
                spring.vx += (targetX - spring.x) * vSpring;
                spring.vy += (targetY - spring.y) * vSpring;
            } else {
                dx = node.x - spring.x;
                dy = node.y - spring.y;
                spring.vx += dx * vSpring;
                spring.vy += dy * vSpring;
            }
            spring.vx *= friction;
            spring.vy *= friction;
        }

        protected function boundSurface(surfaceRectangle:Rectangle, spring:Spring):void {
            if (spring.x < 0 || (spring.x + spring.target.width) > surfaceRectangle.width) {
                spring.vx *= -1;
            }
            if (spring.y < 0 || (spring.y + spring.target.height) > surfaceRectangle.height) {
                spring.vy *= -1;
            }
        }

        protected function enterFrameHandler(e:Event):void {
            if (drawLine) {
                graphics.clear();
                setGraphics(graphics);
            }

            var nodes:Array, node:Spring;
            for each(var spring:Spring in _springs) {
                nodes = spring.nodes;
                if (nodes.length) {
                    for (var i:uint = 0; i < nodes.length; i++) {
                        node = nodes[i];
                        setVelocity(spring, node);
                    }

                    spring.x += spring.vx;
                    spring.y += spring.vy;

                    if (surface) 
                        boundSurface(surface, spring);

                    if (drawLine) {
                        for (i = 0; i < nodes.length; i++) {
                            graphics.moveTo(spring.x, spring.y);
                            graphics.lineTo(nodes[i].x, nodes[i].y);
                        }
                    }
                    spring.dispatchEvent(new Event(Event.CHANGE));
                }
            }
        }

    }
}
