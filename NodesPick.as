package
{
  import Node
  
  import flash.events.*;
  import flash.net.URLRequest;
  import flash.net.URLLoader;
  import Math;
  
  public class NodesPick extends EventDispatcher
  {
    public var gName:Array;
	public var gDesc:Array;
	public var nodesDisplay:Array;
	public var nameRef:Array;
    public var descRef:Array;
	public var temptA:Array;
	
	public var network:XML;
	var XMLLoader:URLLoader;
	public var nodesTotal:uint=0;
	
	public var pickNum:uint;
	public var optionNum:uint;
	
	public var file:String;
	
	
	public function NodesPick(_url:String, _pickNum:uint, _file:String, _optionNum:uint = 3):void
	{
	  gName=new Array();
	  gDesc=new Array();
	  nodesDisplay =new Array();
	  temptA = new Array();
	  nameRef = new Array();
	  descRef = new Array();
	  
	  pickNum = _pickNum;
	  optionNum = _optionNum; //optionNum must <= pickNum. find a way to give a warning if the reverse happens?
	  file = _file;
	  
	  
	  externalLoad(_url);
	}
	
	public function externalLoad(url:String):void
	{
		var XMLUrl:URLRequest=new URLRequest(url+file);
		XMLLoader=new URLLoader(XMLUrl);
		XMLLoader.addEventListener("complete",loadResponse)		
	}
	
	public function loadResponse(e:Event):void
	{
			network=XML(XMLLoader.data);
			nodesTotal=network.node.length();
			
	  var n:Node;
	  var d:Node;
	  var i:uint = 0;
	 
	  for each(var m:XML in network.node)
	  {
	    
		n = new Node(false,m.@name);
		d = new Node(true,m.desc, 0x669999);
		n.index = i;
		d.index = i;
		i++;
		gName.push(n);
		gDesc.push(d);
		
	  }
	  
	  randomPick();
	  randomArrangePicked();
	  
	  var nodesPicked = new Event("nodesPicked", true);
	  dispatchEvent(nodesPicked);
			
	}
	
	public function randomPick():void
	{
	  var t:Array=new Array();
	  var i:uint;
	  for (i=0;i<nodesTotal;i++)
	  {
	    t.push(i);
	  }
	  
	  i = pickNum;
	  var j:uint = nodesTotal;
	  
	  while (i>0)
	  {
	    var k:uint=int(j*Math.random());
		
		  temptA.push(gName[t[k]]);
		  nameRef.push(gName[t[k]]);
		  temptA.push(gDesc[t[k]]);
		  descRef.push(gDesc[t[k]]);
		  
		  
		  t.splice(k, 1);
		  j--;
		  i--;
	   }
	  
	}
	
	public function randomArrangePicked():void 
	{
		var t:Array=new Array();
	    var i:int;
		
	   for (i=0;i<2*pickNum;i++)
	   {
	    t.push(i);
	   }
	   
	   i = 2*pickNum;
	   
	   while (i>0)
	  {
	    var k:uint=int(i*Math.random());
		
		  nodesDisplay.push(temptA[t[k]]);
		  
		  t.splice(k,1);
		  i--
	   }
	   
	}
	
	public function connectPicked():void  
	{
		var i = 0;
		var j = 0;
		var k = 0;
		
		for ( i = 0; i < pickNum; i++)
		{
			nameRef[i].connect(descRef[i]);
		}
		
		nameRef[0].connect(descRef[2]);
		nameRef[0].connect(descRef[4]);
		nameRef[1].connect(descRef[2]);
		nameRef[1].connect(descRef[0]);
        nameRef[2].connect(descRef[1]);
        nameRef[2].connect(descRef[3]);
        nameRef[3].connect(descRef[1]);
        nameRef[3].connect(descRef[5]);
        nameRef[4].connect(descRef[3]);
        nameRef[4].connect(descRef[5]);
        nameRef[5].connect(descRef[0]);
        nameRef[5].connect(descRef[4]);
	}
        
  
  }
}
	   
	   
	   
	   
	   
		
       		
	  
	  