package
{
    import flash.display.Sprite;
    import com.rails2u.core.*;

    public class TestEnum extends Sprite
    {
        public var res:String = '';

        public function TestEnum() {
            var e1:Enumerator = new Enumerator([1,2,3]);
            equ(e1.next(), 1);
            equ(e1.hasNext(), true);
            equ(e1.next(), 2);
            equ(e1.hasNext(), true);
            equ(e1.next(), 3);
            equ(e1.hasNext(), false);
            equ(e1.count, 3);

            equ([[1,4],[2,5],[3,6]], Enumerable.zip([1,2,3], [4,5,6]).to_a(), true);
            equ([[1,4,7],[2,5,8],[3,6,9]], Enumerable.zip([1,2,3], [4,5,6], [7,8,9]).to_a(), true);
            equ([[1,4,7],[2,5,8],[3,6,9]], Enumerable.zip([1,2,3], [4,5,6,10], [7,8,9]).to_a(), true);

            var cycle:Enumerator = Enumerable.cycle([1,2,3]);
            equ(cycle.next(), 1);
            equ(cycle.next(), 2);
            equ(cycle.next(), 3);
            equ(cycle.next(), 1);
            equ(cycle.next(), 2);
            equ(cycle.next(), 3);
            equ(cycle.next(), 1);
            equ(cycle.count, Infinity);
            equ([[1,1],[2,2],[3,3],[4,1]], Enumerable.zip([1,2,3,4], cycle).to_a(), true)
            equ(cycle.next(), 2);
            showResult();
        }

        public function showResult():void {
            log(res);
        }

        public function equ(a:*, b:*, stringnize:Boolean = false):void {
            if(stringnize) {
                a = a.toString();
                b = b.toString();
            }

            if (a==b) {
                res += '.';
            } else {
                log('Error:', a, b);
            }
        }
    }
}
