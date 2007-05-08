package com.rails2u.utils {
    public class StringUtil {
        public static function camelize(s:String, firstLetterInUpperCase:Boolean = true):String {
            if (s.length == 0) return s;

            if (firstLetterInUpperCase) {
                return s.replace(/(^|_)(.)/, function():String {
                    return String(arguments[2]).toUpperCase()
                });
            } else {
                return s.substr(0, 1) + camelize(s.substring(1));
            }
        }
    }
}
