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
	
	public class topBoard extends Sprite
	{
		var timeF:TextField;
		public var timeN:TextField;
		var emailF:TextField;
		var scoreF:TextField;
		var scoreN:TextField;
		var bg:Shape;
		var line:Shape;
		var score:Number = 0;
		
		public function topBoard(_email:String="gg@gmail.com")
		{
			
			bg = new Shape();
			line = new Shape();
			
			//drawOutline();
			drawShape();
			
			timeF = setTF(18,'Time:');
			timeF.x = 38;
			timeF.y = 2;
			addChild(timeF);
			
			scoreF = setTF(18, 'Score:');
			scoreF.x = 595;
			scoreF.y = 2;
			addChild(scoreF);
			
			timeN = setTF(18, '',39,28);
			//trace('fd',timeN.width, timeN.height);
			timeN.x = timeF.width + 32;
			timeN.y = 3;
			addChild(timeN);
			
			
			emailF = setTF(18, _email);
			emailF.x = (127 + 600) / 2 - emailF.width / 2;
			emailF.y = 2;
			addChild(emailF);
			
			scoreN = setTF(45, '0',116,60,0xeeeeee);
			scoreN.x = 710;
			scoreN.y = -8;
			addChild(scoreN);
			
			
		}
		
		function setTF(_size:Number, _s:String = '', _width:Number = -1, _height:Number = -1,
		              _color:Number = 0xFFFFFF , _align:String='center',_font:String = "Verdana"):TextField
		{
			var tf:TextField = new TextField();
			var format:TextFormat=new TextFormat();
		   format.font = _font;
		   format.color = _color;
		   //if(isDesc) format.color=bgColor;
		   format.size = _size;
		   format.align = _align;
		   tf.defaultTextFormat=format;
		   tf.text = _s;
		   
		   if (_width == -1)
		   {
			  tf.height=tf.textHeight+6;
		      tf.width = tf.textWidth + 6;
		   }
		   else
		   {
			   
		      tf.height=_height;
		      tf.width = _width;
		   }
		   
		    tf.mouseEnabled = false;
			return tf;
			
		}
		
		function drawShape()
		{
			var type:String = GradientType.LINEAR;
            var colors:Array = [0xFFFFFF,0x000000]//[0xd49da4, 0xFFFFFF];//cf959b,797979
            var alphas:Array = [0.6, 1];
            var ratios:Array = [0, 255];
            var spreadMethod:String = SpreadMethod.PAD;
            var interp:String = InterpolationMethod.LINEAR_RGB;
            var focalPtRatio:Number = 0;
            var matrix:Matrix = new Matrix();
            var boxWidth:Number = 10;
            var boxHeight:Number = 40;
            var boxRotation:Number = Math.PI/2; // 90°
            var tx:Number = 0;
            var ty:Number = -24;
            matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
            //var square:Shape = new Shape;
            bg.graphics.beginGradientFill(type,colors,alphas,ratios,matrix,spreadMethod,interp,focalPtRatio);

			var t1:Array = calP(6, -32 / 38, 38, 32);
			var t2:Array = calP(6, -40 / (20 + 36), 700, 52);
			//bg.graphics.lineStyle(1, 0);
			//bg.graphics.beginFill(0x001188);
			bg.graphics.moveTo(0,0);
			trace(t1[1].x,t1[1].y);
			bg.graphics.lineTo(t1[1].x, t1[1].y);
			trace(t1[0].x,t1[0].y);
			bg.graphics.curveTo(38,32,t1[0].x, t1[0].y);
			bg.graphics.lineTo(700 - 36, t1[0].y);
			bg.graphics.lineTo(t2[1].x, t2[1].y);
			bg.graphics.curveTo(700,52,t2[0].x, t2[0].y);
			bg.graphics.lineTo(850, 52);
			bg.graphics.lineTo(850, 0);
			bg.graphics.lineTo(0, 0);	
			
			bg.graphics.endFill();
			var i=550;
			bg.graphics.lineStyle(1, 0xFFFFFF);
			bg.graphics.moveTo(i, 2);
			bg.graphics.lineTo(i, 30);
			bg.graphics.moveTo(172, 2);
			bg.graphics.lineTo(172, 30);
			addChild(bg);
			
		}
		
		
		function calP(l:Number, tan:Number, x:Number, y:Number):Array
		{
		   var p1:Point = new Point;
		   var p2:Point;
		   
		   p1.x = x + l;
		   p1.y = y;
		   p2 = Point.polar(l, Math.PI-Math.atan(tan));
		   p2.x = p2.x + x;
		   p2.y = p2.y + y;
		   return [p1, p2];
		}
		
		public function updateScore(_change:Number)
		{
			score += _change;
			scoreN.text = String(score);
		}
		
	}
}
