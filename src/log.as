package {
  import flash.external.ExternalInterface;
  import rails2u.utils.ObjectInspecter;

  public function log(... args):void {
    var r:String = ObjectInspecter.inspect.apply(null, args);
    trace(r)
    ExternalInterface.call('console.log', r);
  }
}
