package
{
    import flash.display.Sprite;
    import org.libspark.as3unit.runner.AS3UnitCore;

    public class TestKeyTypeListener extends Sprite
    {
        public function TestKeyTypeListener() {
            AS3UnitCore.main(TestKeyTypeListenerImpl);
        }
    }
}

import org.libspark.as3unit.test;
import org.libspark.as3unit.before;
import org.libspark.as3unit.after;
use namespace test;
use namespace before;
use namespace after;

import org.libspark.as3unit.assert.assertEquals;
import org.libspark.as3unit.assert.assertTrue;

import com.rails2u.utils.KeyTypeListener;
import com.rails2u.utils.key_down;
import flash.events.KeyboardEvent;

import flash.display.Sprite;
import flash.ui.Keyboard;
import org.libspark.as3unit.assert.assertFalse;

use namespace key_down;

class TestKeyTypeListenerImpl
{
    private var down:String = KeyboardEvent.KEY_DOWN;
    private var up:String = KeyboardEvent.KEY_UP;
    
    before function setup():void {
    }
    
    test function mainKeydown():void
    {
        var result:Array = [];
        var sprite:Sprite = new TestSprite(result);
        KeyTypeListener.attach(sprite);
        
        var events:Array = [];
        var e:KeyboardEvent;
        
        events.push(['F1', keyEvent(down, Keyboard.F1)]);
        events.push(['INSERT', keyEvent(down, Keyboard.INSERT)]);
        events.push(['DOWN', keyEvent(down, Keyboard.DOWN)]);
        events.push(['a', keyEvent(down, 65)]); // 65 is a
        events.push(['0', keyEvent(down, '0')]);
        events.push(['3', keyEvent(down, '3')]);
        e = keyEvent(down, 65);
        e.shiftKey = true;
        events.push(['A', e]);
        
        e = keyEvent(down, 65);
        e.ctrlKey = true;
        events.push(['CTRL_a', e]);
        
        e = keyEvent(down, 65);
        e.shiftKey = true;
        e.ctrlKey = true;
        events.push(['CTRL_A', e]);
        
        var myResult:Array = [];
        for each (var pair:Array in events) {
            myResult.push(pair.shift());
            sprite.dispatchEvent(pair.shift());
        }
        log(result, myResult);
        assertEquals(myResult.sort(), result.sort());
    }
    
    test function destroy1():void 
    {
        var sprite:Sprite = new TestSprite([]);
        KeyTypeListener.attach(sprite);
        KeyTypeListener.detach(sprite);
        
        assertFalse(sprite.hasEventListener(KeyboardEvent.KEY_DOWN));
        assertFalse(sprite.hasEventListener(KeyboardEvent.KEY_UP));
        log('destroy1');
    }
    
    test function destroy2():void 
    {
        var sprite:Sprite = new TestSprite([]);
        var k:KeyTypeListener = KeyTypeListener.attach(sprite);
        k.destroy();
        assertFalse(sprite.hasEventListener(KeyboardEvent.KEY_DOWN));
        assertFalse(sprite.hasEventListener(KeyboardEvent.KEY_UP));
        log('destroy2');
    }
    
    private function keyEvent(type:String, code:*):KeyboardEvent {
        if(code is String) code = String(code).charCodeAt(0);
        code = uint(code);
        return new KeyboardEvent(type, true, false, code, code);
    }
    
    after function tearDown():void {
    }
}

class KeyError extends Error {
    public function KeyError(s:String) {
        super(s);
    }
}

class TestSprite extends Sprite {
    private var result:Array;
    
    public function TestSprite(result:Array) {
        super();
        this.result = result;
    }
    
    key_down function F1():void {
        result.push('F1');
    }
    
    key_down function INSERT(e:KeyboardEvent):void {
        result.push('INSERT');
    }
    
    key_down function DOWN(e:KeyboardEvent):void {
        result.push('DOWN');
    }
    
    key_down function _0():void {
        result.push('0');
    }
    
    key_down function _3():void {
        result.push('3');
    }
    
    key_down function a():void {
        result.push('a');
    }
    
    key_down function A():void {
        result.push('A');
    }
    
    key_down function CTRL_a():void {
        result.push('CTRL_a');
    }
    
    key_down function CTRL_A(e:KeyboardEvent):void {
        result.push('CTRL_A');
    }
    
    key_down function CTRL_1():void {
        result.push('CTRL_1');
    }
}

