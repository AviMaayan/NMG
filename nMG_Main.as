package
{
	
	import flash.display.Shape;
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.system.fscommand;
	import fl.controls.DataGrid;
	import fl.controls.ScrollPolicy;
	
	import flash.net.URLLoader;
    import flash.net.URLRequest;
	import flash.net.*;
	import com.adobe.serialization.json.JSON;
	import flash.utils.describeType;


	import Node;
    import Graph;
    import NodesPick;
	import GameOver;
	import Loading;
	import startBoard.StartScene;
	import PauseBoard;
	import Options;
	
	import Math;
	import flash.geom.Point;
	
	import flash.display.Shape;
    import flash.display.GradientType;
    import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	
	
	public class nMG_Main extends Sprite
	{
       var startScene:StartScene;
	   var oj:Object;
	   var user:String;
	   
	   var pick:NodesPick;
	   var graph:Graph;
	   var gameOver:GameOver;
	   var pauseBoard:PauseBoard;
	   var firstRound:Boolean = true;
	   var mask1:Sprite=new Sprite();
	   
	   var gridOn:Boolean = false;
	   var grid:DataGrid;
	   var line:Shape = new Shape();
	   var options:Options;
	   var loading:Loading = new Loading();

	   var rankData:Array;
	   
	   //var url:String = "http://www.maayanlab.net/NASB15/NMG/nMG/";
	   var url:String = "http://127.0.0.1/NMG/NMG2014/public/nMG/";
	   
	   public function nMG_Main()
	   {
		 oj = this;
		 mask1.graphics.beginFill(0x333333, 0.2);
		 mask1.graphics.drawRect(-200, -200, 2*stage.stageWidth, 2*stage.stageHeight);
		 startScene=new StartScene(stage.stageWidth, stage.stageHeight,url);
		 addChild(startScene);
		 startScene.addEventListener("userConfirmed", function()
		 {
			 afterConfirmed();
		 });
	   }
	   
	   function afterConfirmed():void
	   {
		  if (firstRound)
		  {
		   oj.removeChild(startScene);
		   user = startScene.user;
		   firstRound = false;
		   startScene.firstRound = false;
		  }
		 
		  options = new Options(stage.stageWidth, stage.stageHeight);
		  addChild(options);
		  options.addEventListener('selected', function()
		  { 
		    pick = new NodesPick(url, 6, options.gameFile);
			oj.removeChild(options);
			oj.addChild(loading);
            pick.addEventListener("nodesPicked", afterPicked);
		  });
	   }
	   
	   function afterPicked(e:Event):void
	   {
		   pick.connectPicked();
		   oj.removeChild(loading);
		   graph=new Graph(stage.stageWidth,stage.stageHeight,user);
		   oj.addChild(graph);
		   drawOutline();
		   oj.addChild(graph.board);
		   pauseBoard = new PauseBoard();
		   oj.addChild(pauseBoard);
		   pauseBoard.y = 597.9;
		   //oj.addChild(graph.timeF);
		   pauseBoard.addEventListener(MouseEvent.CLICK, function()
		   {
			   trace(pauseBoard.paused);
			   if (pauseBoard.paused)
			   {
				   pauseBoard.paused = false;
				   oj.removeChild(mask1);
				   pauseBoard.drawPause();
				   graph.downTimer.start();
			   }
			   else
			   {
				   pauseBoard.paused = true;
				   graph.downTimer.stop();
				   pauseBoard.drawResume();
				   oj.addChild(mask1);
				   oj.addChild(graph.board);
				   oj.addChild(pauseBoard);
			   }
		   });
	   
		  graph.nodes=pick.nodesDisplay;

	   setNodesPosition();
	   graph.displayNodes();
	   graph.displayEdges();
	   graph.downTimer.start();
	  
	   trace("what");
	   graph.addEventListener("gameOver", afterGameOver);	
					   
	   }
	   
	   
	   
	   function afterGameOver(e:Event):void
	   {
		   trace("what2");
		graph.downTimer.stop();
		oj.addChild(mask1);
		   
		gameOver = new GameOver();
		gameOver.userName.text = user;
		var timeBonusMultiply = (graph.totalTime - graph.downTimer.currentCount)/graph.totalTime;
		timeBonusMultiply = graph.board.score > 0 ? 1 + timeBonusMultiply : 1 - timeBonusMultiply;
		gameOver.score.text=String( (graph.board.score*timeBonusMultiply).toFixed(1) );
		oj.addChild(gameOver);
		gameOver.x = stage.stageWidth / 2;
		gameOver.y = stage.stageHeight / 2;
		
		var intScore = int(gameOver.score.text);
		var scores = String(intScore);
	    
		gameOver.rank.enabled=false;
		addScores(user,scores);
		
	
	
		gameOver.retry.addEventListener(MouseEvent.CLICK, function()
		{
			trace("in after2  " + gameOver.parent);
			oj.removeChild(graph);
			oj.removeChild(graph.board);
			oj.removeChild(mask1);
			oj.removeChild(gameOver);
			oj.removeChild(line);
			oj.removeChild(pauseBoard);
			if(grid!=null)
			{
			oj.addChild(grid);
		    oj.removeChild(grid);
		}
		    trace('what happenned');
			afterConfirmed();
		});
		
	 }
	 
	 function addScores(user:String,scores:String)
	 {
		 trace(user);
		 var loader:URLLoader = new URLLoader();
		 // add random date.getTime to stop caching
         var request:URLRequest = new URLRequest(url+'addScores.php?email='+
         	user+'&scores='+scores+'&time='+ new Date().getTime());
         trace(url+'addScores.php?email='+user+'&'+'scores='+scores);
         loader.load(request);  
         loader.addEventListener(Event.COMPLETE, onComplete);
		 
		
	 }
         
        function onComplete(e:Event):void
        {
			 trace('in complete');
			 trace(e.target.data);
			 rankData = parseJSON(e.target.data);

			 gameOver.rank.enabled = true;	
			 gridOn = false;
			 gameOver.rank.addEventListener(MouseEvent.CLICK, function()
		   {
			if (gridOn)
			{
				oj.removeChild(grid);
				gridOn = false;
				return;
			}
			
			grid= new DataGrid();
			var col1 = grid.addColumn("User");
			col1.minWidth = 160;
			
			var rankCol = grid.addColumn("Rank");
			rankCol.sortOptions = Array.NUMERIC;

			var col2 = grid.addColumn("TotalScore");
			col2.sortOptions = Array.NUMERIC;
			col2.minWidth = 50;

			var avgCol = grid.addColumn("AvgScore");
			avgCol.sortOptions = Array.NUMERIC;
			

			for each (var u:Array in rankData)
			{
				
				grid.addItem( { User:u[0], Rank:int(u[1]), TotalScore:int(u[2]),AvgScore:int(u[3])} );
			}
			grid.width = 380;
			grid.height = 175;
			grid.x = stage.stageWidth / 2 - grid.width / 2+5;
		    grid.y = stage.stageHeight / 2-grid.height/2-10;
			
			oj.addChild(grid);
			gridOn = true;

	      });
			 
	 }
 		

 	function parseJSON(data:String){
 		data = data.substr(2,data.length-3);
    	var dataArr:Array = data.split(',"');
  		var users:Array = new Array();
  		var topNum = 11;

  		for(var i:int=0; i<topNum; i++){
  				var current:String = dataArr[i];
  				var currentArr:Array = current.split('":');
  				var currentUser:String = currentArr[0];
  				var currentNums:String = currentArr[1];
  				currentNums = currentNums.substr(1,currentNums.length-2);
  				var currentNumsArr:Array = currentNums.split(',');
  				var currentAvgScore:Number = Number(currentNumsArr[0])/Number(currentNumsArr[1]);
  				var currentTotal:Array = new Array(currentUser,currentNumsArr[2],currentNumsArr[0],String(currentAvgScore.toFixed(1)));
  				users.push(currentTotal);
  		}

  		return users;
 	}

		/* function parseJSON2(data:String){
		 var topNum:int = 11;
  		data = data.substr(2,data.length-3);
    	var dataArr:Array = data.split(',"');
  		var users:Array = new Array();
  		if (dataArr.length > topNum)
  		{
  			var userData:String = dataArr[0];
  			userData = userData.substr(5,userData.length-6);
  			var userDataArr:Array = userData.split('":');
  			var userID:String = userDataArr[0];
  			var userNums:String = userDataArr[1];
  			userNums = userNums.substr(1,userNums.length-2);
  			var userNumsArr:Array = userNums.split(',');
  			var userAvgScore:Number = Number(userNumsArr[0])/Number(userNumsArr[1]);
  			var userTotal:Array = new Array(userID,userNumsArr[2],userNumsArr[0],String(userAvgScore.toFixed(1)) );
  			users.push(userTotal);

  			for(var i:int=1; i<=topNum; i++){
  				var current:String = dataArr[i];
  				var currentArr:Array = current.split('":');
  				var currentUser:String = currentArr[0];
  				var currentNums:String = currentArr[1];
  				currentNums = currentNums.substr(1,currentNums.length-2);
  				var currentNumsArr:Array = currentNums.split(',');
  				var currentAvgScore:Number = Number(currentNumsArr[0])/Number(currentNumsArr[1]);
  				var currentTotal:Array = new Array(currentUser,String(i),currentNumsArr[0],String(currentAvgScore.toFixed(1)));
  				users.push(currentTotal);

  			}
  			return users;
  		}
  		else{

  			for(var i:int=0; i<topNum; i++){
  				var current:String = dataArr[i];
  				var currentArr:Array = current.split('":');
  				var currentUser:String = currentArr[0];
  				var currentNums:String = currentArr[1];
  				currentNums = currentNums.substr(1,currentNums.length-2);
  				var currentNumsArr:Array = currentNums.split(',');
  				var currentAvgScore:Number = Number(currentNumsArr[0])/Number(currentNumsArr[1]);
  				var currentTotal:Array = new Array(currentUser,String(i+1),currentNumsArr[0],String(currentAvgScore.toFixed(1)));
  				users.push(currentTotal);

  			}
  			return users;
  		}
  	}*/


		 function setNodesPosition0():void
		 {
			   var nx:Number=100;
	   var ny:Number=200;
	   
	   var dx:Number=150;
	   var dy:Number=450;
          //var even:Boolean=false;
	   for each (var n:Node in graph.nodes)
	   {
		   if(!n.isDesc)
		   {
			   n.setXY(nx,ny);
			   nx+=100;
		   }
		   else
		   {
			   n.setXY(dx,dy);
			   dx+=100;
		   }
	   }	
		 }
		 
		 function setNodesPosition():void
		 {
			var n:uint = pick.pickNum;
			var nodes:Array = graph.nodes;
			var po:Point;
			var p:Array = new Array();
			var len:Number = 200;
			
			p[0] = new Array();
			p[1] = new Array();
			
			var i = 0;
			for (i = 0; i < n; i++)
			{
				po = Point.polar(1 / 2 * len, -2 * Math.PI / n*i);
				p[0][i] = [stage.stageWidth/2 + po.x, stage.stageHeight/2 + po.y];
				po = Point.polar(len, -2 * Math.PI / n * i);
				p[1][i] = [stage.stageWidth/2 + po.x, stage.stageHeight/2 + po.y];
			}
			
			
			var nodesR:Array = new Array();
			var j:Number = 0;
			for (i = 0; i < 2*n; i++)
			{
				nodesR[i] = new Array();
				j = 0;
				for each ( var e:Edge in nodes[i].edges)
				{
					if (e.nn == nodes[i])
					nodesR[i][j++] = nodes.indexOf(e.nd);
					else
					nodesR[i][j++] = nodes.indexOf(e.nn);
				}
				nodesR[i][j] = false;
			}
			
			
		
			
		    var k1:uint = 0;
			var k2:uint = 0;
			k1 = nodesR[0][0];
			k2 = nodesR[0][1];
			var nl:Array = bCheck(k1, k2);
			if (nl.length == 1)
				k1 = nodesR[0][2];
			else
			{
				k2 = nodesR[0][2];
				nl = bCheck(k1, k2);
				if (nl.length == 1)
				k1 = nodesR[0][1];
			}
			
			  nodes[0].setXY(p[0][0][0], p[0][0][1]);
			  nodesR[0][3] = true;
			  nodes[k2].setXY(p[0][1][0], p[0][1][1]);
			  nodesR[k2][3] = true;
			  nodes[k1].setXY(p[1][0][0], p[1][0][1]);
			  nodesR[k1][3] = true;
			  
			i = 1;
			j = 2;
			var count:uint = 3;
			while (1)
			{
				nl = bCheck(k1, k2);
				if (nodesR[nl[0]][3]== false) k1 = nl[0];
				else k1 = nl[1];
				nodes[k1].setXY(p[1][i][0], p[1][i][1]);
				i++;
			    nodesR[k1][3] = true;
				if (++count == 2*n) break;
				
				k2 = sCheck(k2);
				nodes[k2].setXY(p[0][j][0], p[0][j][1]);
				j++;
			    nodesR[k2][3] = true;
				if (++count == 2*n) break;
			}
			
			

			function bCheck(_k1:uint, _k2:uint):Array  //both check: return their shared nodes.
		    {
			  var a:Array = new Array();
			   var k = 0;
			for (var ii = 0; ii < 3; ii++)
			{
				for (var jj = 0; jj < 3; jj++)
				{
					if (nodesR[_k1][ii] == nodesR[_k2][jj])
					a[k++] = nodesR[_k1][ii];
				}
			}
			     return a;
		   }
		   
		   function sCheck(_k2:uint):uint  //self check: return the _k2's connected node that has not been setXY()
		   {
			 var num:uint;
			for (var ii = 0; ii < 3; ii++)
			{
				if (nodesR[nodesR[_k2][ii]][3] == false)
				num=nodesR[_k2][ii];
			}
			 return num;
		   }
		 }
	    
		 
		 function drawOutline():void
		{
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
            matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
            //var square:Shape = new Shape;
			line.graphics.lineStyle(4);
            line.graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			line.graphics.moveTo(0, 0);
		    line.graphics.lineTo(0, 300);
			line.graphics.moveTo(848, 0);
			line.graphics.lineTo(848, 300);
			line.graphics.endFill();
			
			boxRotation = boxRotation + Math.PI;
			ty=300
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
            line.graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			//graphics.beginGradientFill(type,colors,alphas,ratios,matrix,spreadMethod,interp,focalPtRatio);
			//graphics.drawRect(0,0,600,600);
			line.graphics.moveTo(0, 300);
			line.graphics.lineTo(0,600);
            line.graphics.moveTo(848, 300);
			line.graphics.lineTo(848, 600);
			
			boxRotation=0;
			ty=0;
			tx=35;
			boxWidth= 175;
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
            line.graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			line.graphics.moveTo(0,600);
			line.graphics.lineTo(200,600);
			
			boxRotation=Math.PI;
			tx=165;
			boxWidth=400;
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);
            line.graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
			//line.graphics.moveTo(0,500);
			line.graphics.lineTo(850,600);
			
			
			
			addChild(line);
			
			
			
		}
  }
}