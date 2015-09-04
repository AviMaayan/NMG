package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Node;
	
	public class Edge extends Sprite
	{
		public var nn:Node;
		public var nd:Node;
		
		public var nam:String;
		
		public var edgeColor:uint;
		
		public var marked:Boolean = false;//mainly used for marking whether be blended
		
		public function Edge(_edgeColor:uint=0x000000):void
		{
            edgeColor = _edgeColor;
			
			addEventListener(MouseEvent.MOUSE_OVER, function():void
			{
				drawFocusLine();
				nn.drawEdgedShape();
				nd.drawEdgedShape();
			});
			
			addEventListener(MouseEvent.MOUSE_OUT, function():void
			{
				drawLine();
				nn.drawShape();
				nd.drawShape();
			});
			
			
		}
		
		public function drawLine():void
		{
			x = nn.x;
			y = nn.y;
			
			graphics.clear();
			graphics.lineStyle(1, edgeColor);
			graphics.lineTo(nd.x - nn.x, nd.y - nn.y);
		}
		
		public function drawFocusLine():void
		{
			
			x=nn.x;
			y=nn.y;
			
			graphics.clear();
			graphics.lineStyle(4, edgeColor);
			graphics.lineTo(nd.x - nn.x, nd.y - nn.y);
		}
		
	}
}