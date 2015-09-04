package
{
  
  import Node;
  import Edge;
  
  import flash.display.Sprite;
  import flash.events.*;
  import flash.utils.Timer;
  import flash.text.TextFormat;
  import flash.text.TextField;
  
  import topBoard;
  
  public class Graph extends Sprite
  {
     public var nodes:Array;
	 public var draggedNode:Node;
	
	public var lappedNode:Node;          // these two variables are to prevent the situation that previous
	public var previousdraggedNode:Node; // draggedNode keeps transparent while the lappedNode is dragged up.
	
	public var firstMove:Boolean = true;
    //public var priordraggedNode:Node;
	public var underNode:Node;
	
	public var board:topBoard;
	
	var oj:Graph;
	
	var stageW:Number;
	var stageH:Number;
	
    var blendTimer:Timer = new Timer(70);
	
	public var totalTime = 45;
	var downTimer:Timer;
	
	private var gameOver:Event;
	
	public function setCountDown():void
	{
		downTimer.addEventListener(TimerEvent.TIMER, function()
		{
			board.timeN.text = String(totalTime - downTimer.currentCount);
		});
		
		downTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function()
		{
			gameOver = new Event("gameOver", true);
			dispatchEvent(gameOver);
		});
	}
	
	public function Graph(_stageWidth:Number,_stageHeight:Number,_email:String):void
	 {
	   stageW = _stageWidth;
	   stageH = _stageHeight;
		 
	   nodes=new Array();
	   drawBackground();
	   
	   board=new topBoard(_email);
	   //addChild(board);
	   
	   
	   oj = this;
	   downTimer = new Timer(1000, totalTime);
	   setCountDown();
	   
	 }
	 
	 public function drawBackground()
	 {
		 graphics.beginFill(0xFFFFFF,1);
		 graphics.drawRect(-200,-200,1000,1000);
	 }
	 
	 public function preDisplay():void
	 {
	   lappedNode=new Node();
	   addEventListener(MouseEvent.MOUSE_MOVE, function():void
	   {
	     if (!isDragged()) return;
		 
		 if(draggedNode==lappedNode) previousdraggedNode.alpha=1;
		 
		 if(isOverlapped()) 
		  {
			  draggedNode.alpha=0.6;
			  lappedNode.drawFocusShape();
			  previousdraggedNode=draggedNode;
		  }
		 else 
		 {
			 draggedNode.alpha=1;
			 lappedNode.drawShape();
		 }
		});
		
		addEventListener(MouseEvent.MOUSE_MOVE, function():void
		{
			if (!isDragged()) return;
			
			for each (var e:Edge in draggedNode.edges)
			{
				
				
				if (e.nn != draggedNode)
				{
					var et:Node = e.nn;
					e.nn = draggedNode;
					e.nd = et;
				}
				
				e.drawFocusLine();
				
			}
		});
		
		addEventListener(MouseEvent.MOUSE_MOVE, function():void
		{
			if (!isDragged()) return;
			
			if (!(stage.mouseX > 10 && stage.mouseX < stageW-10 && stage.mouseY > 10 && stage.mouseY < stageH-10))
		 {
			 firstMove = true;
			 draggedNode.removeEventListener(MouseEvent.MOUSE_UP, judge);
			 
			 stopDrag();
			 draggedNode.dragged = false;
			 draggedNode.x = draggedNode.nailedX;
			 draggedNode.y = draggedNode.nailedY;
			 return;
		 }
		});
		
		addEventListener(MouseEvent.MOUSE_MOVE, function():void
	   {
	     if (!isDragged()) return;
		 
		
		 
		// priordraggedNode = draggedNode;
		 if(firstMove)
		 {
			 firstMove = false;
			 draggedNode.addEventListener(MouseEvent.MOUSE_UP, judge);
			 //maybe needed to add a MouseOut event with identical function judge;answer:no need.
		 }
	   });
	   
	     addEventListener(MouseEvent.DOUBLE_CLICK, function():void
		 {
			 for each( var n:Node in nodes)
			 {
				 if (n.descTxtShow)
				 {
					 if (!n.mouseIn())
					 {
						 n.parent.removeChild(n.descTxt);
				         n.descTxtShow=false;
					 }
				 }
			 }
		 });
		 
		 addEventListener(MouseEvent.MOUSE_MOVE,function():void
		 {
			 if (!isDragged()) return;
			 
			 for each (var n:Node in nodes)
			 {
				 if (n.descTxtShow)
				 {
				  n.parent.removeChild(n.descTxt);
				  n.descTxtShow=false;
				 }
			 }
		 });
		 
		 for each(var n:Node in nodes)
		 {
			 n.addEventListener(MouseEvent.MOUSE_OVER, function(e:Event)
			 {
				 var n1 = e.target;
				 n1.marked = true;
				 n1.alpha = 1;
				 for each(var e1:Edge in n1.edges)
				 {
					 e1.marked = true;
					 e1.alpha = 1;
					 e1.nn.marked = true;
					 e1.nn.alpha = 1;
					 e1.nd.marked = true;
					 e1.nd.alpha = 1;
				 }
				 
				 oj.blend();
			 });
			 
			 n.addEventListener(MouseEvent.MOUSE_OUT, function(e:Event)
			 {
				 var n1 = e.target;
				 n1.marked = false;
				 for each(var e1:Edge in n1.edges)
				 {
					 e1.marked = false;
					 e1.nn.marked = false;
					 e1.nd.marked = false;
				 }
				 
				 oj.deBlend();
			 });
		 }
	  }
	  
	  public function judge(e:Event):void
	   {
				firstMove = true;
				
				underNode=null;
				for each(var n:Node in nodes)
		        {
		          if(n.mouseIn()&&n!=draggedNode) 
		           {
					 underNode = n;
		           }
			    }
				
				if (underNode == null) 
	            {
					draggedNode.x = draggedNode.nailedX;
					draggedNode.y = draggedNode.nailedY;
					
					draggedNode.removeEventListener(MouseEvent.MOUSE_UP, judge);
					return;
				}
				
				if (underNode.isDesc ==draggedNode.isDesc)
				{
					draggedNode.x = draggedNode.nailedX;
					draggedNode.y = draggedNode.nailedY;
					
					draggedNode.alpha = 1;
					//drawshap, drawedge?
					//board.updateScore(-10);
					
					draggedNode.removeEventListener(MouseEvent.MOUSE_UP, judge);
					return;
			    }
				
				if (underNode.index != draggedNode.index)
				{
					draggedNode.x = draggedNode.nailedX;
					draggedNode.y = draggedNode.nailedY;
					//drawshap, drawedge?
					draggedNode.alpha = 1;
					scoreChange(false, underNode.x, underNode.y);
					
					
					draggedNode.removeEventListener(MouseEvent.MOUSE_UP, judge);
					return;
				}
				
				draggedNode.removeEventListener(MouseEvent.MOUSE_UP, judge);
				gotRightAnswer();
				return;
	   }
	  
	   public function gotRightAnswer():void
	   {
		   
			
			for each (var e:Edge in draggedNode.edges)
			if(e.parent!=null) e.parent.removeChild(e);
			
			for each (e in underNode.edges)
			if (e.parent != null) e.parent.removeChild(e);
			
			scoreChange(true, underNode.x, underNode.y);
			
			underNode.parent.removeChild(underNode);
			draggedNode.parent.removeChild(draggedNode);
			
			
			
			nodes.splice(nodes.indexOf(draggedNode),1);
			nodes.splice(nodes.indexOf(underNode), 1);
			
			
			if (nodes.length==0)
			{
				gameOver = new Event("gameOver", true);
				dispatchEvent(gameOver);
			}
			
			
	   }
	   
	   function scoreChange(_right:Boolean,_x:Number,_y:Number):void
	   {
		    board.updateScore(_right?10:-50);
		   
		   var s=new Sprite();


             addChild(s);
             s.x=_x;
             s.y=_y>stageH/2?_y+50:_y-50;

          var format:TextFormat=new TextFormat();
		   format.font="Verdana";
		   format.color=_right?0x00DD55:0xFF0000;
		   //if(isDesc) format.color=bgColor;
		   format.size=_right?20:25;
		   format.bold=true;

         var tf=new TextField();
         tf.defaultTextFormat=format;
          tf.text=_right?"+10":"-50";
          tf.height=tf.textHeight+6;
          tf.width=tf.textWidth+6;
          tf.x=-tf.width/2;
          tf.y=-tf.height/2;
          tf.mouseEnabled=false;
          s.addChild(tf);

          s.alpha=0.7;
		   
		   var timer:Timer = new Timer(41, 7);
		   timer.addEventListener(TimerEvent.TIMER, function():void
		   {
			   
			    if (_right)
				{
			    s.scaleX *= 1.2;
				s.scaleY *= 1.2;
				}
			   
			   if (timer.currentCount > 2)
			   {
			    s.alpha -= 0.1;
				
			   }
			   
			   //if(timer.currentCount==5) board.updateScore(_right?10:-10);
		   });
		   
		   timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void
		   {
			   oj.removeChild(s);
			   s = null;
		   });
		   
		   timer.start();
	   }
	   
	    public function displayNodes():void
		{
			preDisplay();
			
			for each(var n:Node in nodes)
			{
				addChild(n);
			}
			
		}
		
		public function displayEdges():void
        {
          for each(var n:Node in nodes)
			{
				if(!n.isDesc) n.displayEdges();
			}
         }
	  
	  public function isDragged():Boolean
	  {
	    for each (var n:Node in nodes)
	   {
	     if(n.dragged) 
		 {
		  draggedNode=n;
		  return true;
		 }
	   }
	    return false;
	  }
	  
	  public function isOverlapped():Boolean
	  {
	    for each (var n:Node in nodes)
		{
		  if(n.mouseIn()&&(!n.dragged)) 
		  {
			  lappedNode=n;
			  return true;
		  }
		}
		  return false;
	  }
	  
	 public function blendOut(evt:TimerEvent):void
	 {
			
			
			for each (var n:Node in nodes)
			{
				if (!n.marked)
				{
					n.alpha = Math.max(n.alpha-0.12, 0.3);
				}
				
				for each (var e:Edge in n.edges)
				{
					if (e.nn == n)
					{
						if (!e.marked)
						{
						 e.alpha = Math.max(e.alpha-0.12, 0.3);
						}
					}
				}
			}
	 }
	 
	 public function blendIn(evt:TimerEvent):void
	 {
			
			
			for each (var n:Node in nodes)
			{
				if (!n.marked)
				{
					n.alpha = Math.min(n.alpha+0.35, 1);
				}
				
				for each (var e:Edge in n.edges)
				{
					if (e.nn == n)
					{
						if (!e.marked)
						{
						 e.alpha = Math.min(e.alpha+0.35, 1);
						}
					}
				}
			}
	 }
	  
	  public function blend()
	  {
			blendTimer.stop();
			blendTimer.removeEventListener(TimerEvent.TIMER, blendIn);
			blendTimer.addEventListener(TimerEvent.TIMER, blendOut);
			blendTimer.start();
	 }
	 
	 public function deBlend()
	 {
			blendTimer.stop();
			blendTimer.removeEventListener(TimerEvent.TIMER, blendOut);
			blendTimer.addEventListener(TimerEvent.TIMER, blendIn);
			blendTimer.start();
			//blendTimer = setInterval(blendOut, 100);
	}
	  
   }
}
		 
		 