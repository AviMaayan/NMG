package
{
	import flash.display.Sprite;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	
	import flash.display.Shape;
    import flash.display.GradientType;
    import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import flash.text.TextFormat;
	
	public class PauseBoard extends Sprite
	{
		var bg:Shape = new Shape();
		public var pause:Shape = new Shape();
		var w1:Number = 25;
		var w2:Number = 45;
		var h:Number = 20;
		var r:Number = 7;
		var h1:Number = -9;
		var mrg:Number = 3;
		var r1:Number = 10;
		var paused:Boolean = false;
		
		public function PauseBoard()
		{
			drawBg();
			addChild(bg);
			drawPause();
			//drawResume();
			addChild(pause);
		}
		
		function drawPause():void
		{
			pause.graphics.clear();
			pause.graphics.lineStyle(2, 0xFFFFFF,0);
			pause.graphics.drawCircle(200, h1, r1+3);
			pause.graphics.endFill();
			pause.graphics.lineStyle(3,0xFFFFFF);
			pause.graphics.moveTo(200 - mrg, r1 / 2 + h1);
			pause.graphics.lineTo(200 - mrg, h1 - r1 / 2);
			pause.graphics.moveTo(200 + mrg, r1 / 2 + h1);
			pause.graphics.lineTo(200 + mrg, h1 - r1 / 2);
		}
		function drawResume():void
		{
			var p:Array = new Array();
			p.push(Point.polar(r, 0));
			p.push(Point.polar(r, 2 * Math.PI / 3));
			p.push(Point.polar(r, 2 * 2 * Math.PI / 3));
			
			for each (var po:Point in p)
			{
				po.x += 200;
				po.y += h1;
			}
			pause.graphics.clear();
			pause.graphics.lineStyle(2, 0xFFFFFF,0);
			pause.graphics.drawCircle(200, h1, r+3);
			pause.graphics.endFill();
			pause.graphics.beginFill(0xFFFFFF);
			pause.graphics.moveTo(p[0].x, p[0].y);
			pause.graphics.lineTo(p[1].x, p[1].y);
			pause.graphics.lineTo(p[2].x, p[2].y);
			pause.graphics.lineTo(p[0].x, p[0].y);
			pause.graphics.endFill();
			
		}
		
		
		function calPL(l:Number, tan:Number, x:Number, y:Number):Array
		{
		   var p1:Point = new Point;
		   var p2:Point;
		   
		   p1.x = x + l;
		   p1.y = y;
		   p2 = Point.polar(l, Math.PI+Math.atan(tan));
		   p2.x = p2.x + x;
		   p2.y = p2.y + y;
		   return [p1, p2];
		}
		
		function calPR(l:Number, tan:Number, x:Number, y:Number):Array
		{
		   var p1:Point = new Point;
		   var p2:Point;
		   
		   p1.x = x - l;
		   p1.y = y;
		   p2 = Point.polar(l, Math.atan(tan));
		   p2.x = p2.x + x;
		   p2.y = p2.y + y;
		   return [p1, p2];
		}
		
		function drawBg():void
		{
			var t1:Array = new Array();
			var t2:Array = new Array();
            var type:String = GradientType.LINEAR;
            var colors:Array = [0xFFFFFF,0x000000]//[0xd49da4, 0xFFFFFF];//cf959b,797979
            var alphas:Array = [0.6, 1];
            var ratios:Array = [0, 255];
            var spreadMethod:String = SpreadMethod.PAD;
            var interp:String = InterpolationMethod.LINEAR_RGB;
            var focalPtRatio:Number = 0;
            var matrix:Matrix = new Matrix();
            var boxWidth:Number = 850;
            var boxHeight:Number = 300;
            var boxRotation:Number = Math.PI/2; // 90°
            var tx:Number = 0;
            var ty:Number = 0;
            //matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
            //var square:Shape = new Shape;
			
			t1 = calPL(4, -(w2 - w1) / h, -w1, -h);
			t2 = calPR(4, (w2 - w1) / h, w1, -h);
			
			boxRotation=0;
			ty=0;
			tx=35;
			boxWidth= 175;
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
			bg.graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
            //line.graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			//bg.graphics.drawRect(0, 0, 500, 500);
			//bg.graphics.lineStyle(2, 0x000000);
			bg.graphics.moveTo(200, 0);
			bg.graphics.lineTo( 200-w2, 0);
			bg.graphics.lineTo(200+t1[1].x, t1[1].y);
			bg.graphics.curveTo( 200-w1, -h, 200+t1[0].x, t1[0].y);
			bg.graphics.lineTo(200, -h);
			bg.graphics.lineTo(200, 0);
			bg.graphics.endFill();
			
			trace("g");
			boxRotation=Math.PI;
			tx=165;
			boxWidth=500;
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
           bg.graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
            //line.graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			bg.graphics.moveTo(200, 0);
			bg.graphics.lineTo(200+w2, 0);
			bg.graphics.lineTo(200+t2[1].x, t2[1].y);
			bg.graphics.curveTo( 200+w1, -h, 200+t2[0].x, t2[0].y);
			bg.graphics.lineTo(200, -h);
			bg.graphics.lineTo(200, 0);
			bg.graphics.endFill();
			
		}
	}
}