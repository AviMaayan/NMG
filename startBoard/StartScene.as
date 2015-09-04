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
		public var user:String;
		
	    var uBoard:userBoard = new userBoard();
		var rBoard:registerBoard = new registerBoard();
		var dFormat:TextFormat;
		var eFormat:TextFormat;
		var oj:StartScene;
		
		var stageW:Number;
	    var stageH:Number;
		
		var url:String;
		var responseStr:String;
		
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
				
				var loader:URLLoader = new URLLoader();
         		var request:URLRequest = new URLRequest(url+'checkUser.php?email='+eml+'&'+'password='+pass);
         		loader.load(request);
         		loader.addEventListener(Event.COMPLETE, function(event:Event):void
         			{
         				responseStr = event.target.data;
         				if(responseStr=='noSuchUser'){
         					uBoard.message.text = "user not found";
							return;
         				}
         				else if(responseStr =='passwordWrong'){
         					uBoard.message.text = "Wrong password";
							return;
         				}
         				else if(responseStr == 'Authenticized'){
         					user = eml;
         					userConfirmed= new Event("userConfirmed",true);
			  				dispatchEvent(userConfirmed);
         					return;
         				}
         				else{
         					uBoard.message.text = 'Network Error: Please re-click OK';
         					return;
         				}
         				});
				
			});// end of OK.click
			

			
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
				
				
			 var loader:URLLoader = new URLLoader();
         		var request:URLRequest = new URLRequest(url+'addUser.php?email='+eml+'&'+'password='+pass1);
         		loader.load(request);
         		loader.addEventListener(Event.COMPLETE, function(event:Event):void
         			{
         				responseStr = event.target.data;
         				if(responseStr=='added'){
         					user = eml;
         					userConfirmed= new Event("userConfirmed",true);
			  				dispatchEvent(userConfirmed);
         					return;
         				}
         				else if(responseStr=='emailRegistered'){
         					rBoard.message.text = 'This email is registered.Please change another one';
         					return;
         				}
         				else if(responseStr=='FailedToWrite'){
         					rBoard.message.text = 'Write Error: Please re-click Register';
         					return;
         				}
         				else{
         					rBoard.message.text = 'Network Error: Please re-click Register';
         					return;
         				}
         			});
					
			}); // end of register.click

			
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