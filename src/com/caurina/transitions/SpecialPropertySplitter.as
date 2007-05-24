package caurina.transitions {

	/**
	 * SpecialPropertySplitter
	 * A proxy setter for special properties
	 *
	 * @author		Zeh Fernando
	 * @version		1.0.0
	 * @private
	 */

	public class SpecialPropertySplitter {

		public var splitValues:Function;

		/**
		 * Builds a new group special property object.
		 * 
		 * @param		p_splitFunction		Function	Reference to the function used to split a value 
		 */
		public function SpecialPropertySplitter (p_splitFunction:Function) {
			splitValues = p_splitFunction;
		}

		/**
		 * Converts the instance to a string that can be used when trace()ing the object
		 */
		public function toString():String {
			var value:String = "";
			value += "[SpecialPropertySplitter ";
			value += "splitValues:"+String(splitValues); // .toString();
			value += "]";
			return value;
		}

	}

}
