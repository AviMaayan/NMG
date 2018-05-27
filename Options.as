package
{
	import flash.display.Sprite;
	import Option;
	import flash.events.*;
	import Node;
	
	public class Options extends Sprite
	{
		var selected:Event;
		var gameFile:String;
		
		public function Options(_sWidth:Number,_sHeight:Number)
		{
				var p1:Option = new Option('Teams-PIs');
			var p2:Option = new Option('KCs-Leads');
			var p3:Option = new Option('KCs-Topics');
			var p4:Option = new Option('Teams-PMs');
			var p5:Option = new Option('Teams-KCs');


			
			p1.x = _sWidth / 2;
			p2.x = _sWidth / 2;
			p3.x = _sWidth / 2;
			p4.x = _sWidth / 2;
			p5.x = _sWidth / 2;

			
			p5.y = _sHeight / 2 - 180;
			p4.y = _sHeight / 2 - 90;
			p2.y = _sHeight / 2;
			p1.y = _sHeight / 2 + 90;
			p3.y = _sHeight / 2 + 180;
			

			
			p1.addEventListener(MouseEvent.CLICK, function()
			{
				gameFile = 'teams_pis_network.xml';
				selected= new Event("selected",true);
			    dispatchEvent(selected);
			});

			p2.addEventListener(MouseEvent.CLICK, function()
			{
				gameFile = 'kcs_leads_network.xml';
				selected= new Event("selected",true);
			    dispatchEvent(selected);
			});
			
			p3.addEventListener(MouseEvent.CLICK, function()
			{
				gameFile = 'kcs_topics_network.xml';
				selected= new Event("selected",true);
			    dispatchEvent(selected);
			});
			
			p4.addEventListener(MouseEvent.CLICK, function()
			{
				gameFile = 'teams_pms_network.xml';
				selected= new Event("selected",true);
			    dispatchEvent(selected);
			});
			
			p5.addEventListener(MouseEvent.CLICK, function()
			{
				gameFile = 'teams_kcs_network.xml';
				selected= new Event("selected",true);
			    dispatchEvent(selected);
			});
			
			
			addChild(p1);
			addChild(p2);
			addChild(p3);
			addChild(p4);
			addChild(p5);



			

		}

		
	}
}
