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
	
	import flash.events.MouseEvent;
	
	public class Option extends Sprite
	{
		var tf:TextField = new TextField();
		var w:Number = 200;
		var h:Number = 70;
		var type:String = GradientType.LINEAR;
        var colors:Array = [0xaaaaaa,0x000000]//[0xd49da4, 0xFFFFFF];//cf959b,797979
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
			var ty:Number = -40;
		
		public function Option(_str:String):void
		{
			
			
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
			
			drawShape();
			
			tf = setTF(25, _str);
			tf.x = -tf.width / 2;
			tf.y = -tf.height / 2;
			addChild(tf);
			
			addEventListener(MouseEvent.MOUSE_OVER, function()
			{
				drawFocusShape();
			});
			
			addEventListener(MouseEvent.MOUSE_OUT, function()
			{
				drawShape();
			});
			
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
			
			//var square:Shape = new Shape;
			graphics.clear();
			graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			graphics.lineStyle(2);
			graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			graphics.drawRoundRect( -w / 2, -h / 2, w, h, 20);
			graphics.endFill();
			
		}
		
		function drawFocusShape()
		{
			graphics.clear();
			graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			graphics.drawRoundRect( -w / 2, -h / 2, w, h, 20);
			graphics.endFill();
			graphics.lineStyle(4, 0xF76541);
			graphics.drawRoundRect( -w / 2-1.5, -h / 2-1, w + 3, h + 3, 20);
			graphics.endFill();
		}
	}
}