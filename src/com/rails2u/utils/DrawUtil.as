package com.rails2u.utils {
    import flash.display.Graphics;

    public class DrawUtil {
        public static function drawStar(graphics:Graphics,                                                                                        xPos:Number = 0,
                yPos:Number = 0,
                sides:uint = 5,
                innerRadius:Number = 20,
                outerRadius:Number = 50,
                type:String = 'line'
                ):void {
            var theta:Number = 0.0;
            var incr:Number = Math.PI * 2.0 / sides;
            var halfIncr:Number = incr / 2.0;
            for (var i:uint = 0; i <= sides; i++) {
                if(i == 0) {
                    if (type == 'curve') {
                        graphics.moveTo(innerRadius * Math.cos(theta + halfIncr) + xPos, innerRadius * Math.sin(theta + halfIncr) + yPos);
                    } else {
                        graphics.moveTo(outerRadius * Math.cos(theta) + xPos, outerRadius * Math.sin(theta) + yPos);
                    }
                }
                if (type == 'curve') {
                    graphics.curveTo(                                                                                                                 outerRadius * Math.cos(theta) + xPos, outerRadius * Math.sin(theta) + yPos,                                                       innerRadius * Math.cos(theta + halfIncr) + xPos, innerRadius * Math.sin(theta + halfIncr) + yPos
                            );
                } else {
                    graphics.lineTo(outerRadius * Math.cos(theta) + xPos, outerRadius * Math.sin(theta) + yPos);
                    graphics.lineTo(innerRadius * Math.cos(theta + halfIncr) + xPos, innerRadius * Math.sin(theta + halfIncr) + yPos);
                }
                theta += incr;
            }
        }
    }
}
