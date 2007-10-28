package com.rails2u.engine {
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    import flash.events.EventDispatcher;

    public class Spring extends EventDispatcher {
        public var target:DisplayObject;
        public var vx:Number = 0;
        public var vy:Number = 0;
        public var defaultNodeLength:Number;
        protected var _nodes:Array = [];
        public var nodesLength:Dictionary = new Dictionary();

        public function Spring(target:DisplayObject) {
            this.target = target;
        }

        public function addNode(node:Spring, len:Number = NaN):Spring {
            if (hasNode(node) || node == this) 
                return undefined;

            _nodes.push(node);
            if (!isNaN(len)) {
                setNodeLength(node, len);
            } else if (!isNaN(defaultNodeLength)) {
                setNodeLength(node, defaultNodeLength);
            }
            return node;
        }

        public function removeNode(node:Spring):Spring {
            if (!hasNode(node)) 
                return undefined;

            if(getNodeLength(node)) 
                delete nodesLength[node];
            _nodes.splice(_nodes.indexOf(node), 1);
            return node;
        }

        public function hasNode(node:Spring):Boolean {
            return _nodes.indexOf(node) == -1 ? false : true;
        }

        public function refNode(node:Spring, len:Number = NaN):Spring {
            if (node == this) return undefined;

            node.addNode(this);
            if (!isNaN(len)) node.setNodeLength(this, len);
            return node;
        }

        public function setNodeLength(node:Spring, len:Number):void {
            nodesLength[node] = len;
        }

        public function getNodeLength(node:Spring):Number {
            return nodesLength[node];
        }

        public function get nodes():Array {
            return _nodes;
        }

        public function get x():Number {
            return target.x;
        }

        public function set x(val:Number):void {
            target.x = val;
        }

        public function get y():Number {
            return target.y;
        }

        public function set y(val:Number):void {
            target.y = val;
        }
    }
}

