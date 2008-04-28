package
{
    import flash.display.Sprite;
    import com.rails2u.utils.KeyTypeListener;
    import com.rails2u.utils.key_down;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.display.StageAlign;
    import com.rails2u.utils.ColorUtil;
    use namespace key_down;
    
    public class KeyTypeListenerExample2 extends Sprite
    {
        public function KeyTypeListenerExample2() {
            stage.align = StageAlign.TOP_LEFT;
            KeyTypeListener.attach(stage, this);
            init();
        }
        
        key_down function after(e:KeyboardEvent):void {
            currentChild.dispatchEvent(e);
        }
        
        private function init():void {
            for (var i:uint = 0; i < 400; i++) {
                createBall();
            }
        }
        
        private function createBall():void {
            var ball:Ball = new Ball(
	            ColorUtil.random(64,64,64), 
	            20 + 40 * Math.random()
            );
            ball.alpha = 0.7 + 0.2 * Math.random()
            ball.x = stage.stageWidth * Math.random();
            ball.y = stage.stageHeight * Math.random();
            ball.addEventListener(MouseEvent.MOUSE_DOWN, mouseClickHandler);
            addChild(ball);
        }
        
        private function mouseClickHandler(e:MouseEvent):void {
            setChildIndex(Sprite(e.target), numChildren - 1);
        }
        
        private function mouseClickHandelr(e:MouseEvent):void {
            setChildIndex(Sprite(e.target), numChildren - 1);
        }
        
        private function get currentChild():DisplayObject {
            return getChildAt(numChildren - 1);
        }
        
        key_down function DELETE():void {
            removeChild(currentChild);
        }
        
        key_down function INSERT():void {
            createBall();
        }
    }
}

import flash.display.Sprite;
import com.rails2u.utils.KeyTypeListener;
import com.rails2u.utils.key_down;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.display.DisplayObject;
import flash.display.StageAlign;
use namespace key_down;

class Ball extends Sprite
{
    private var radius:Number;
    private var color:uint;
        
    public function Ball(color:uint, radius:uint) {
        this.color = color;
        this.radius = radius;
        KeyTypeListener.attach(this);
        init();
    }
        
    public function init():void {
        graphics.beginFill(color);
        graphics.drawCircle(0,0,radius);
        graphics.endFill();
    }
            
    key_down function DOWN(e:KeyboardEvent):void {
        y += 1;
    }
        
    key_down function UP(e:KeyboardEvent):void {
        y -= 1;
    }
        
    key_down function LEFT(e:KeyboardEvent):void {
        x -= 1;
    }
        
    key_down function RIGHT(e:KeyboardEvent):void {
        x += 1;
    }
    
    // stop event
    key_down function after(e:KeyboardEvent):void {
        e.stopPropagation();
    }
}
