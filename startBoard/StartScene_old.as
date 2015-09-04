package startBoard
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	

	import startBoard.registerBoard;
	import startBoard.userBoard;
	
	import flash.events.*;
	import flash.utils.Timer;
	
	import flash.net.URLLoader;
    import flash.net.URLRequest;
	import flash.net.*;
	
	import fl.controls.TextInput;
	
	public class StartScene extends Sprite
	{
		public var uData:XML;
		public var user:XML;
		
	    var uBoard:userBoard = new userBoard();
		var rBoard:registerBoard = new registerBoard();
		var dFormat:TextFormat;
		var eFormat:TextFormat;
		var oj:StartScene;
		
		var stageW:Number;
	    var stageH:Number;
		
		var url:String;
		
		var userConfirmed:Event;
		public var firstRound:Boolean = true;
		
		public function StartScene(_stageWidth:Number,_stageHeight:Number,_url:String):void
		{

			oj = this;
			url = _url;
			
			stageW = _stageWidth;
	        stageH = _stageHeight;
			
			uBoard.x = rBoard.x = stageW / 2;
			uBoard.y = rBoard.y = stageH / 2;
			
		 var loader:URLLoader = new URLLoader();
         var request:URLRequest = new URLRequest(url+'nMG_userData.xml'+"?cache=" + new Date().getTime());
         loader.load(request);
         loader.addEventListener(Event.COMPLETE, onComplete);
		}
		
		
        function onComplete(event:Event):void
        {
			uData = XML(event.target.data);
			trace(uData);
			
			addChild(uBoard);
			
			dFormat = new TextFormat();
			dFormat.size = 17;
			dFormat.color = 0xBBBBBB;
			
			eFormat = new TextFormat();
			eFormat.size = 17;
			eFormat.color = 0x000000;
			
			setInputTextFormat(uBoard.email, 'Email', dFormat, eFormat);
			setInputTextFormat(uBoard.password, 'Password', dFormat,  eFormat, true);
			setInputTextFormat(rBoard.email, 'Email', dFormat, eFormat);
			setInputTextFormat(rBoard.password1, 'password', dFormat,  eFormat, true);
			setInputTextFormat(rBoard.password2, 'Re-type password', dFormat,  eFormat, true);
			
			uBoard.OK.addEventListener(MouseEvent.CLICK, function():void
				// User login board with click OK event
			{
				var eml:String = uBoard.email.text;
				var pass:String = uBoard.password.text;
				
				if (uBoard.message.text != "") uBoard.message.text= "";
				if (eml.indexOf("@") == -1||eml.indexOf(" ")!=-1)
				{
					uBoard.message.text = "Please input a valid E-mail";
					return;	
				}
				if (eml.indexOf(".", eml.indexOf("@"))==-1)
				{
					uBoard.message.text = "Please input a valid E-mail";
					return;	
				}
				
				if (uData.user.(email == eml) == undefined)
				{
					uBoard.message.text = "user not found";
					return;
				}
				
				if (uData.user.(email == eml).password != pass)
				{
					uBoard.message.text = "Wrong password";
					return;
				}
				
			  user = XML(uData.user.(email == eml));
			  removeData(user.email.toString());
				
			});
			
			//var rBoard:registerBoard = new registerBoard();
			//rBoard.alpha = 0;
			//addChildAt(rBoard, 0);
			rBoard.rotationY = -180;
			
			var rotationTimer:Timer = new Timer(10, 30);
			rotationTimer.addEventListener(TimerEvent.TIMER,function():void
					{
						uBoard.rotationY+=6;
						rBoard.rotationY+=6;

						if(uBoard.rotationY>90)
						oj.addChild(rBoard);
					});
					
			rotationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void
			           {
						   rBoard.transform.matrix3D = null;
						   rBoard.x = uBoard.x;
						   rBoard.y = uBoard.y;
						  
					   });
			
			uBoard.newUser.addEventListener(MouseEvent.CLICK, function():void
			{
				rotationTimer.start();
			});
			
			rBoard.register.addEventListener(MouseEvent.CLICK, function():void
			{
				
				var eml:String = rBoard.email.text;
				var pass1:String = rBoard.password1.text;
				var pass2:String = rBoard.password2.text;
				
				
				if (rBoard.message.text != "") rBoard.message.text = "";
				if (eml.indexOf("@") == -1||eml.indexOf(" ")!=-1)
				{
					rBoard.message.text = "Please input a valid E-mail";
					return;	
				}
				if (eml.indexOf(".", eml.indexOf("@"))==-1)
				{
					rBoard.message.text = "Please input a valid E-mail";
					return;	
				}
				
				if (uData.user.(email == eml) != undefined)
				{
					rBoard.message.text = "e-mail alreay registered,change another";
					return;
				}
				if (pass1 == "")
				{
					rBoard.message.text = "please input password";
					return;
				}
				if (pass1!=pass2)
				{
					rBoard.message.text = "type the passwords identical";
					return;
				}
				
				
			  var emlX:XML = XML("<email>"+eml+"</email>");
              var passX:XML = XML("<password>" + pass1 + "</password>");
			  var totalScore:XML =<totalScore></totalScore>;
			  //var rank:XML =<rank></rank>;
			  user =<user></user>;
			  
			  user.appendChild(emlX);
			  user.appendChild(passX);
			  user.appendChild(totalScore);
			 // user.appendChild(rank);
			  //uData.appendChild(user);
			  
			  //myso.data.xml = uData;
			  //myso.flush();
			  
			  userConfirmed= new Event("userConfirmed",true);
			  dispatchEvent(userConfirmed);
				
			});
			
			uBoard.email.addEventListener(FocusEvent.FOCUS_IN, function()
			{
				uBoard.message.text= "";
			});
			
			uBoard.password.addEventListener(FocusEvent.FOCUS_IN, function()
			{
				uBoard.message.text = "";
			});
			
			rBoard.email.addEventListener(FocusEvent.FOCUS_IN, function()
			{
				rBoard.message.text = "";
			});
			
			rBoard.password1.addEventListener(FocusEvent.FOCUS_IN, function()
			{
				rBoard.message.text = "";
			});
			
			rBoard.password2.addEventListener(FocusEvent.FOCUS_IN, function()
			{
				rBoard.message.text= "";
			});
		}
		/*public function removeUser(u:XML)
	   {
	    var uList:XMLList = uData.user;
	    for (var i:int = 0; i < uList.length(); i++)
	   {
		   if (uList[i] == u)
		   {
			   delete uList[i];
			   break;
		   }
	    }
		   
	   }*/
	   
	   public function removeData(email:String)
		{
			var mes:String = 'email='+email;
			var variables:URLVariables = new URLVariables(mes);
            var request:URLRequest = new URLRequest();
            request.url = url + 'removeData.php';
            request.method = URLRequestMethod.POST;
            trace("removeData");
           request.data = variables;
           var loader:URLLoader = new URLLoader();
		   loader.load(request);
          //loader.dataFormat = URLLoaderDataFormat.VARIABLES;
         loader.addEventListener(Event.COMPLETE, function ()
		 {

			 if (firstRound)
			 {
				
			 userConfirmed= new Event("userConfirmed",true);
			  dispatchEvent(userConfirmed);
			 }
		 });
		}
		
		function setInputTextFormat ( input:TextInput, defaultText:String, dFormat:TextFormat, 
		                              eFormat:TextFormat, encrypt:Boolean = false, padFormat:Number = 2.5)
        {
	        input.setStyle('textPadding', padFormat);//set top-margin
			input.setStyle('textFormat', dFormat);
			input.text = defaultText;
			input.addEventListener(FocusEvent.FOCUS_IN, function():void
			{
				input.setStyle('textFormat', eFormat);
				if (input.text == defaultText)
				{
				input.text = '';
				if(encrypt) input.displayAsPassword = true;
				}
			});
			input.addEventListener(FocusEvent.FOCUS_OUT, function():void
			{
				if (input.text == '')
				{
			    input.setStyle('textFormat', dFormat);
				input.text = defaultText;
				if(encrypt) input.displayAsPassword = false;
				}
			});
          }
		
	}
	
	
}