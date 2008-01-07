package {
    import com.rails2u.utils.ObjectUtil;

    public class SimpleTest {
        public var detail:Boolean = false;

        public var count:uint = 0;
        public var successedCount:uint = 0;
        public var failedCount:uint = 0;

        public var testName:String = '';

        public function SimpleTest(testName:String = '') {
            this.testName = testName;
        }

        public function run(f:Function):void {
            try {
                log(testName + ' test start.');
                // log(testName + '[' + count.toString()  +' test(s)] start.');
                f.call(this);
                finish();
            } catch(e:Error) {
                log(e.getStackTrace());
            }
        }

        public function ok(res:*):void {
            count++;
            if (res) {
                success(res.toString() + " is ok.");
            } else {
                fail(res.toString() + " is not ok.");
            }
        }

        public function notOk(res:*):void {
            count++;
            if (res) {
                success(res.toString() + " is not ok.");
            } else {
                fail(res.toString() + " is ok.");
            }
        }

        public function opEquals(a:*, b:*):void {
            count++;
            if (a == b) {
                success(a.toString() + " is " + b + '.');
            } else {
                fail(a.toString() + " is not " + b + '.');
            }
        }

        public function notOpEquals(a:*, b:*):void {
            count++;
            if (a != b) {
                success(a.toString() + " is not " + b + '.');
            } else {
                fail(a.toString() + " is " + b + '.');
            }
        }

        public function equals(a:*, b:*):void {
            count++;
            var _a:String = ObjectUtil.inspect(a);
            var _b:String = ObjectUtil.inspect(b);
            if (_a == _b) {
                success(a.toString() + " is " + b + '.');
            } else {
                fail(a.toString() + " is not " + b + '.');
            }
        }

        public function notEquals(a:*, b:*):void {
            count++;
            var _a:String = ObjectUtil.inspect(a);
            var _b:String = ObjectUtil.inspect(b);
            if (_a != _b) {
                success(a.toString() + " is not " + b + '.');
            } else {
                fail(a.toString() + " is " + b + '.');
            }
        }

        public function finish():void {
            if (count == successedCount) {
                log(count.toString() + " test(s) is all successed!");
            } else {
                log(count.toString() + " test(s) running: " + failedCount.toString() +" error: " + successedCount.toString() + " success.");
            }
        }

        protected function success(s:String):void {
            successedCount++;
            if (detail) {
                showSuccess(s);
            }
        }

        protected function fail(s:String):void {
            failedCount++;
            var mes:String = (new SimpleTestError(s)).getStackTrace();
            var at:String = 'at SimpleTest';
            var buildinCall:String = '2006/builtin::';
            showFail(
                mes.split("\n").filter(function(i:String, ind:int, a:Array):Boolean { 
                    return i.indexOf(at) == -1 && i.indexOf(buildinCall) == -1
                    }).join("\n")
            );
        }

        protected function showFail(mes:String):void {
            log(mes);
        }
        protected function showSuccess(mes:String):void {
            log(mes);
        }
    }
}

class SimpleTestError extends Error {
    public function SimpleTestError(m:String="", id:int=0) {
        super(m, id);
        name = 'SimpleTestError';
    }
}
