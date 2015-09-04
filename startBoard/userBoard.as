package startBoard
{
	import flash.display.MovieClip;
	
	public class userBoard extends MovieClip
	{
		//password,email,OK,newUser
		public function userBoard() {
			
			OK.label = "Begin";
			newUser.label = "NewUser";	
			email.tabIndex = 1;
			password.tabIndex = 2;
			newUser.tabIndex = 4;
			OK.tabIndex = 3;
		}
	}
}