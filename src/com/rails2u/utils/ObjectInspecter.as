package rails2u.utils
{
    import flash.utils.getQualifiedClassName;
    
    public class ObjectInspecter
    {
        /*
          *
          */
        public static function inspect(... args):String {
            return inspectImpl(args, false);
        }
        
	    internal static function inspectImpl(arg:*, bracket:Boolean = true):String {
	        var className:String = getQualifiedClassName(arg);
	        var str:String; var results:Array;
	
	        switch(getQualifiedClassName(arg)) {
	            case 'Object':
	            case 'Dictionary':
	                /*
	                results = [];
	                for (var key:* in arg) {
	                    results.push(inspectImpl(key) + ':' + inspectImpl(arg[key], false));
	                }
	                str = classFormat(className, '{' + results.join(', ') + '}');
	                */
	                str = classFormat(className, arg);
	                break;
	            case 'Array':
	              results = [];
	              for (var i:uint = 0; i < arg.length; i++) {
	                  results.push(inspectImpl(arg[i]));
	              }
	              if (bracket) {
	                str = '[' + results.join(', ') + ']';
	              } else {
	                str = results.join(', ');
	              }
	              break;
	            case 'int':
	            case 'uint':
	            case 'Number':
	              str = arg.toString();
	              break;
	            case 'String':
	              str = arg;
	              break;
	            default:
	              str = classFormat(className, arg);
	        }
	        return str;
	    }
	    
	    internal static function classFormat(className:String, arg:*):String {
	         return '#<' + className + ':' + String(arg) + '>';
	    }
    }
}