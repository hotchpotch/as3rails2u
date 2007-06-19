package com.rails2u.utils {
    import flash.display.Graphics;
    import flash.geom.Rectangle;
    import flash.display.Shape;

    public class DrawUtil {
        public static function drawStar(graphics:Graphics, 
                xPos:Number = 0,
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
                    graphics.curveTo(outerRadius * Math.cos(theta) + xPos, outerRadius * Math.sin(theta) + yPos,
                    innerRadius * Math.cos(theta + halfIncr) + xPos, innerRadius * Math.sin(theta + halfIncr) + yPos);
                } else {
                    graphics.lineTo(outerRadius * Math.cos(theta) + xPos, outerRadius * Math.sin(theta) + yPos);
                    graphics.lineTo(innerRadius * Math.cos(theta + halfIncr) + xPos, innerRadius * Math.sin(theta + halfIncr) + yPos);
                }
                theta += incr;
            }
        }


        public static function drawStarLight(graphics:Graphics, 
                xPos:Number = 0,
                yPos:Number = 0,
                sides:uint = 10,
                innerRadius:Number = 10,
                outerRadius:Number = 30,
                type:String = 'line',
                sizePercent:Number = 4/5
                ):void {
            var theta:Number = 0.0;
            var incr:Number = Math.PI * 2.0 / sides;
            var halfIncr:Number = incr / 2.0;
            for (var i:uint = 0; i <= sides; i++) {
                var rOuterRadius:Number = MathUtil.randomBetween(outerRadius * sizePercent, outerRadius);
                if(i == 0) {
                    if (type == 'curve') {
                        graphics.moveTo(innerRadius * Math.cos(theta + halfIncr) + xPos, innerRadius * Math.sin(theta + halfIncr) + yPos);
                    } else {
                        graphics.moveTo(rOuterRadius * Math.cos(theta) + xPos, rOuterRadius * Math.sin(theta) + yPos);
                    }
                }
                if (type == 'curve') {
                    graphics.curveTo(rOuterRadius * Math.cos(theta) + xPos, rOuterRadius * Math.sin(theta) + yPos,
                    innerRadius * Math.cos(theta + halfIncr) + xPos, innerRadius * Math.sin(theta + halfIncr) + yPos);
                } else {
                    graphics.lineTo(rOuterRadius * Math.cos(theta) + xPos, rOuterRadius* Math.sin(theta) + yPos);
                    graphics.lineTo(innerRadius * Math.cos(theta + halfIncr) + xPos, innerRadius * Math.sin(theta + halfIncr) + yPos);
                }
                theta += incr;
            }
        }

        public static function drawCenterSquare(graphics:Graphics, size:uint = 10, autoLineStyle:Boolean = true):void {
            if (autoLineStyle) simpleLineStyle(graphics);
            graphics.drawRect(-size / 2, -size / 2, size, size);
            graphics.moveTo(-size / 2, -size / 2);
            graphics.lineTo(size / 2, size / 2);
            graphics.moveTo(-size / 2, size / 2);
            graphics.lineTo(size / 2, -size / 2);
        }

        public static function drawRectangle(graphics:Graphics, rec:Rectangle, autoLineStyle:Boolean = true):void {
            if (autoLineStyle) simpleLineStyle(graphics);
            graphics.drawRect(rec.x, rec.y, rec.width, rec.height);
        }

        public static function drawFrame(d:Shape, autoLineStyle:Boolean = true):void {
            drawRectangle(d.graphics, d.getRect(d), autoLineStyle);
        }

        public static function simpleLineStyle(graphics:Graphics):void {
            graphics.lineStyle(0, 0xEEEEEE);
        }
    }
}
