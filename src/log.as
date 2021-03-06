package {
  import flash.external.ExternalInterface;
  import com.rails2u.utils.ObjectUtil;
  import flash.utils.getQualifiedClassName;

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
    var r:String = ObjectUtil.inspect.apply(null, args);
    trace(r)
    if (ExternalInterface.available) {
        var arg:* = args.length == 1 ? args[0] : args;

        try {
            ExternalInterface.call(<><![CDATA[ 
                (function(obj, klassName) {
                    obj.toString = function() { return klassName };
                    console.log(obj);
                ;})
            ]]></>.toString(),
                ObjectUtil.clone(arg),
                getQualifiedClassName(arg)
            );
        } catch(e:Error) {
            ExternalInterface.call('console.log', r);
        }
    }
    return r;
  }
}
