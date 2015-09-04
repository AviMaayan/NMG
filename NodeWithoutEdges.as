package
{
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.*;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import Math;
   
   import flash.display.*;
  // import fl.controls.UIScrollBar;

   public class NodeWithoutEdges extends Sprite
   {
	   public var isDesc:Boolean=false;
	   public var index:uint;
	   
	   public var txtF:TextField=new TextField();
       public var txt:String="";
	   public var txtColor:uint;
	   public var txtSize:Number = 10;
	   //public var scrollBar:UIScrollBar = new UIScrollBar();	
	   
	   
	   public var radius:Number=10;
	   
	   public var bgColor:uint;
	   public var focusLineColor:uint;
	   
	   public var dragged:Boolean=false;
	   public var mouseInside:Boolean=false;
	   
	   var oj:NodeWithoutEdges; 
	   
	   
	   public function NodeWithoutEdges(_isDesc:Boolean=false,_txt:String="Node", _bgColor:uint=0x6698FF, _focusLineColor:uint=0xF76541, _txtColor:uint=0xFFFFFF)
	   {
		   
		   x=100;
		   y=100;
		   oj=this;
		   
		   isDesc=_isDesc;
		   txt=_txt;
		   txtColor=_txtColor;
		   bgColor=_bgColor;
		   focusLineColor=_focusLineColor;
		   
		   if(!isDesc) setTxt();
		   
		   drawShape();
		   
		   addEventListener(MouseEvent.MOUSE_OVER, function():void
		   {
			   drawFocusShape();
			   Mouse.cursor=MouseCursor.BUTTON;
			   parent.addChild(oj);
			   
		   });
		   
		   addEventListener(MouseEvent.MOUSE_OUT,function():void
		   {
			   drawShape();
			   Mouse.cursor=MouseCursor.ARROW;
			   //stopDrag();
			   //dragged = false;
		   });
		   
		   addEventListener(MouseEvent.MOUSE_DOWN,function():void
		   {
			   startDrag();
			   dragged=true;
		   });
		   
		   addEventListener(MouseEvent.MOUSE_UP, function():void
		   {
			   stopDrag();
			   dragged=false;
		   });
		   
		   
	   }
	   
	   public function setTxt():void
	   {
		   var format:TextFormat=new TextFormat();
		   format.font="Verdana";
		   format.color=txtColor;
		   //if(isDesc) format.color=bgColor;
		   format.size=txtSize;
		   
		   txtF.defaultTextFormat = format;
		   while (txt.length > 20)
				txt = txt.substring(0, txt.length-2);
		   txtF.text=txt;
		   if(isDesc) txt="Node";
		   
		   txtF.height=txtF.textHeight+6;
		   txtF.width=txtF.textWidth+6;
		   
		   txtF.x=-txtF.width/2;
		   txtF.y=-txtF.height/2;
		   
		   txtF.mouseEnabled=false;
		   
		   addChild(txtF);
	   }
	   
	   
	   public function drawShape():void
	   {
		   if (isDesc)
		   {
		    graphics.clear();
			graphics.beginFill(bgColor, 1);
			graphics.drawCircle( 0, 0, radius+5);
			//graphics.drawRoundRect(-25,-10,50,20,5,5);
			graphics.endFill();
			return;
		   }
		   else
		   {
		   graphics.clear();
		   graphics.beginFill(bgColor,1);
		   graphics.drawRoundRect(-(txtF.width+8)/2,-radius,txtF.width+8,radius*2,0.8 * radius,0.8 * radius);
		   //graphics.drawRect(0, 0, 50, 50);
		   graphics.endFill();
		   }
	   }
	   
	   public function drawFocusShape():void
	   {
		   if (isDesc)
		   {
			graphics.clear();
			graphics.lineStyle(4,focusLineColor);
			graphics.beginFill(bgColor, 1);
			graphics.drawCircle( 0, 0, radius+5);
			//graphics.drawRoundRect(-25,-10,50,20,5,5);
			graphics.endFill();
			return;
		   }
		   else
		   {
		    graphics.clear();
			graphics.lineStyle(4,focusLineColor);
			graphics.beginFill(bgColor,1);
			graphics.drawRoundRect(-(txtF.width+8)/2,-radius,txtF.width+8,radius*2,0.8 * radius,0.8 * radius);
			graphics.endFill();
		   }
	   }
	   
	   public function mouseIn():Boolean
	   {
		  if (!isDesc)
		  {
		  var dx:Number=parent.mouseX-(x-(txtF.width+8)/2);
		  var dy:Number=parent.mouseY-(y-radius);
		  if(dx>0&&dx<width&&dy>0&&dy<height) return true;
		  return false;
		  }
		  else 
		  {
			  dx = parent.mouseX - x;
			  dy = parent.mouseY - y;
			  var distance:Number = Math.sqrt(dx * dx + dy * dy);
			  
			  if (distance <= radius + 5) return true;
			  return false;
		  }
		  
	   }
		   
   }
}
	   
	
		   