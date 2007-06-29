package {
  import flash.external.ExternalInterface;
  import com.rails2u.utils.ObjectInspecter;

  /**
  * log() is Object inspect dump output to trace() and use 
  * Browser(FireFox, Safari and more) External API console.log.
  * 
  * example
  * <listing version="3.0">
  * var a:Array = [[1,2,3], [4,[5,6]]];
  * var sprite:Sprite = new Sprite;
  * log(a, sprite);
  * # output
  * [[1, 2, 3], [4, [5, 6]]], #&lt;flash.display::Sprite:[object Sprite]&gt;
  * </listing>
  */  
  public function log(... args):String {
    var r:String = ObjectInspecter.inspect.apply(null, args);
    trace(r)
    ExternalInterface.call('console.log', r);
    return r;
  }
}
