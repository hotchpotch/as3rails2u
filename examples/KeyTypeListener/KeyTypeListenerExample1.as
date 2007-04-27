package
{
    import com.rails2u.utils.KeyTypeListener;
    import com.rails2u.utils.key_down;
    use namespace key_down;
    
    import flash.display.Sprite;
    
    import com.rails2u.utils.key_up;
    use namespace key_up;
    
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import com.rails2u.utils.ColorUtil;
    import flash.display.StageAlign;
    import flash.events.KeyboardEvent;

    public class KeyTypeListenerExample1 extends Sprite
    {
        public function KeyTypeListenerExample1()
        {
            super();
            stage.align = StageAlign.TOP_LEFT;
            for (var i:uint = 0; i < 400; i++) {
                createBall();
            }
            KeyTypeListener.attach(stage, this);
        }
        
        private function createBall():void {
            var ball:Sprite = new Sprite;
            var g:Graphics = ball.graphics;
            g.beginFill(ColorUtil.random(64,64,64), 0.7 + 0.2 * Math.random());
            g.drawCircle(0,0, 20 + 40 * Math.random());
            ball.x = stage.stageWidth * Math.random();
            ball.y = stage.stageHeight * Math.random();
            ball.addEventListener(MouseEvent.MOUSE_DOWN, mouseClickHandler);
            addChild(ball);
        }
        
        private function mouseClickHandler(e:MouseEvent):void {
            setChildIndex(Sprite(e.target), numChildren - 1);
        }
        
        private function get currentChild():DisplayObject {
            return getChildAt(numChildren - 1);
        }
        
        key_down function DOWN():void {
            currentChild.y += 1;
        }
        
        key_down function UP():void {
            currentChild.y -= 1;
        }
        
        key_down function LEFT():void {
            currentChild.x -= 1;
        }
        
        key_down function RIGHT():void {
            currentChild.x += 1;
        }
        
        key_down function DELETE():void {
            removeChild(currentChild);
        }
        
        key_down function INSERT():void {
            createBall();
        }
        
        // if function define argument, call with argument KeyboardEvent.
        key_down function v(event:KeyboardEvent):void {
            log(event);
        }
        
        /**
        * more examples function
        */
        // aliases
        // alias j key to DOWN
        key_down function j():void {
           DOWN();
        }
        
        key_down function k():void {
           UP();
        }
        
        key_down function l():void {
           RIGHT();
        }
        
        key_down function h():void {
           LEFT();
        }
        
        // SHIFT + j
        key_down function J():void {
            log('keydown SHIFT + j');
        }
        
        // CTRL + j
        key_down function CTRL_j():void {
            log('keydown CTRL + j');
        }
        
        // CTRL + SHIFT + j
        key_down function CTRL_J():void {
            log('keydown CTRL + SHIFT + j');
        }
        
        // NUM keydown
        key_down function _1():void {
            log('keydown 1');
        }
        
        key_down function _8():void {
            log('keydown 8');
        }
        
        // keyup, use key_up namespace.
        key_up function a():void {
            log('keyup a');
        }
    }
}