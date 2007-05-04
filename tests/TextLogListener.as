package {
    import org.libspark.as3unit.runner.Description;
    import org.libspark.as3unit.runner.Result;
    import org.libspark.as3unit.runner.notification.Failure;
    import org.libspark.as3unit.runner.notification.RunListener;
    
    public class TextLogListener extends RunListener
    {
        private var buffer:String;
        
        public function TextLogListener()
        {
            buffer = '';
        }
        
        public override function testRunFinished(result:Result):void
        {
            printHeader(result.runTime);
            printFailures(result);
            printFooter(result);
        }
        
        public override function testStarted(description:Description):void
        {
            print('.');
        }
        
        public override function testFailure(failure:Failure):void
        {
            print('E');
        }
        
        public override function testIgnored(description:Description):void
        {
            print('I');
        }
        
        protected function printHeader(runTime:uint):void
        {
            println();
            println('Time: ' + elapsedTimeAsString(runTime));
        }
        
        protected function printFailures(result:Result):void
        {
            if (result.failureCount == 0) {
                return;
            }
            if (result.failureCount == 1) {
                println('There was ' + result.failureCount + ' failure:');
            }
            else {
                println('There were ' + result.failureCount + ' failures:');
            }
            var i:uint = 0;
            for each (var failure:Failure in result.failures) {
                printFailure(failure, ++i);
            }
        }
        
        protected function printFailure(failure:Failure, count:uint):void
        {
            printFailureHeader(failure, count);
            printFailureTrace(failure);
        }
        
        protected function printFailureHeader(failure:Failure, count:uint):void
        {
            println(count + ') ' + failure.testHeader);
        }
        
        protected function printFailureTrace(failure:Failure):void
        {
            println(failure.trace);
        }
        
        protected function printFooter(result:Result):void
        {
            if (result.wasSuccessful) {
                println();
                print('OK');
                println(' (' + result.runCount + ' test' + (result.runCount == 1 ? '' : 's') + ')');
            }
            else {
                println();
                println('FAILURES!!!!');
                println('Tests run: ' + result.runCount + ', Failure: ' + result.failureCount);
            }
            println();
        }
        
        protected function elapsedTimeAsString(runTime:uint):String
        {
            return String(runTime / 1000);
        }
        
        private function print(str:String):void
        {
            buffer += str;
            if (buffer.length >= 80) {
                println();
            }
        }
        
        private function println(str:String=''):void
        {
            log(buffer + str);
            buffer = '';
        }
    }
}
