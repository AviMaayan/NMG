package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.*;
	import fl.controls.UIScrollBar;
	
	import Edge;
	
	public class Node extends NodeWithoutEdges
	{
		
		public var edges:Array;
		//public var onEdge:Boolean=false;
		
		public var descTxt:Sprite = new Sprite();
	    public var descTxtShow = false;
	    public var nailedX:Number;
	    public var nailedY:Number;
		public var id:uint;
		
		public var descF:TextField = new TextField();
		var scrollBar:UIScrollBar;
		
		public var marked:Boolean = false;//mainly used for marking whether be blended
		
		var ojj:Node;
		
		public function Node( _isDesc:Boolean=false,_txt:String="Node", _bgColor:uint=0x6698FF, _focusLineColor:uint=0xF76541, _txtColor:uint=0xFFFFFF)
		{
			super(_isDesc,_txt, _bgColor, _focusLineColor, _txtColor);
			if (isDesc) setDescTxt();
			edges = new Array();
			ojj = this;
			
			addEventListener(MouseEvent.MOUSE_OVER, function():void
			{
				for each (var e:Edge in ojj.edges)
				
				{
				
					e.drawFocusLine();
				}
			});
			
			addEventListener(MouseEvent.MOUSE_OUT, function():void
			{
					//x = nailedX;
					//y = nailedY;
				
				if (!dragged)
				{
				   for each (var e:Edge in ojj.edges)
					{
					  e.drawLine();
					}
				}
					
					
			});
			

			if (isDesc)
	       {
	         
			/* addEventListener(MouseEvent.MOUSE_MOVE,function():void
			 {
				 if(!dragged) return;
				 
				 if(descTxtShow)
				 {
				  parent.removeChild(descTxt);
				  descTxtShow=false;
				 }
			 });*/
			 
			 doubleClickEnabled = true;
			 addEventListener(MouseEvent.DOUBLE_CLICK, function ():void
		    {
			    if (!descTxtShow)
			   {  
				 parent.addChild(descTxt);
				 parent.addChild(ojj);
			
			     setDescTxtCoordinates();
			     descTxtShow = true;
				 return;
			    }
			    else
			   {
			     parent.removeChild(descTxt);
				 descTxtShow = false;
				 return;
			   }
		    });
		   }
		   
				
		}
		
		public function connect(_n:Node):void
		{
			
			var e:Edge = new Edge();
			e.nn = this;
			e.nd = _n;
			e.nam = this.txt+"node";
			edges.push(e);
			_n.edges.push(e);
			
			
		}
		
		public function ifConnect(_n:Node):Boolean
	    {
		     for each (var e:Edge in edges)
			 {
				 if (this == e.nn)
				 {
					 if (e.nd == _n)
					 return true;
				 }
				 else
				 {
					 if (e.nn == _n)
					 return true;
				 }
			 }
			 
			 return false;
	    }
		
		public function displayEdges():void
		{
			for each(var e:Edge in edges)
			{
				parent.addChildAt(e, 0);
				e.drawLine();
			}
		}
		
		public function drawEdgedShape():void
		{
			if (!isDesc)
			{
			graphics.clear();
			graphics.lineStyle(4,edges[0].edgeColor);
			graphics.beginFill(bgColor,1);
			graphics.drawRoundRect(-(txtF.width+8)/2,-radius,txtF.width+8,radius*2,0.8 * radius,0.8 * radius);
			graphics.endFill();
			}
			else
			{
				graphics.clear();
			    graphics.lineStyle(4, edges[0].edgeColor);
				graphics.beginFill(bgColor, 1);
				graphics.drawCircle(0, 0, radius + 5);
				graphics.endFill();
			}
		}
	
		public function setDescTxt():void
		{
			var format:TextFormat=new TextFormat();
		   format.font="Verdana";
		   format.color=txtColor;
		   format.size=txtSize;
		   
		   descF.defaultTextFormat = format;
		   descF.height=200;
		   descF.width = 150;
		   descF.x = -(descF.width + 15) / 2; 
		   descF.y = -descF.height / 2;
		   
		   descF.mouseEnabled = false;
		   descF.border = true;
		   descF.borderColor = 0x005544;
		   descF.wordWrap=true;
		   descF.text = txt;
		   
		   descTxt.addChild(descF);
		  
		   
		   
		   
		   var marginX:Number=7;
		   var marginY:Number=8;
		   
		   
		   scrollBar = new UIScrollBar();
		   scrollBar.x =-descF.x-scrollBar.width;
		   scrollBar.y =descF.y;
		   scrollBar.height = descF.height+1;
		   
		   scrollBar.scrollTarget = descF;
		     
		   descTxt.addChild(scrollBar);
		  
		   descTxt.graphics.beginFill(bgColor, 1);
		   descTxt.graphics.drawRoundRect( -(descF.width + 2*marginX+scrollBar.width) / 2-2, -(descF.height + 2*marginY) / 2, descF.width + 2*marginX+scrollBar.width, descF.height + 2*marginY, radius, radius);
		   descTxt.graphics.endFill();
		   
		   if (scrollBar.enabled == false) scrollBar.alpha = 0.6;
		  
		   
		   
		   
		   
		   
		    //scrollBar.update();
		}
		
		
		public function setXY(_x:Number, _y:Number):void
		{
			nailedX = _x;
			x = _x;
			nailedY = _y;
			y = _y;
		}
		
		public function setDescTxtCoordinates():void
		{
			var centerX = stage.stageWidth / 2;
			var centerY = stage.stageHeight / 2;
			
			
			if (x - centerX < 0 && y - centerY < 0)
		    {
				descTxt.x = x + radius + 1.2*descF.width / 2 + 10;
				descTxt.y = y + radius + descTxt.height / 2;
				return;
			}
			if (x - centerX >= 0 && y - centerY <= 0)
			{
				descTxt.x = x - radius - 1.2*descF.width / 2 - 10;
				descTxt.y = y + radius + descTxt.height / 2;
				return;
			}
			if (x - centerX<=0&&y-centerY>=0)
			{
			    descTxt.x = x + radius + 1.2*descF.width / 2 + 10;
				descTxt.y = y - radius -descTxt.height / 2;
				return;	
			}
			if (x - centerX > 0 && y - centerY > 0)
			{
				descTxt.x = x -radius - 1.2*descF.width / 2 - 10;
				descTxt.y = y - radius -descTxt.height / 2;
				return;	
			}
		}
	}
}