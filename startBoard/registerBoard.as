package startBoard
{
	import flash.display.MovieClip;
	
	public class registerBoard extends MovieClip
	{
		
		public function registerBoard() {
			
			register.label = "Register and begin";	
			
			email.tabIndex = 5;
			password1.tabIndex = 6;
			password2.tabIndex = 7;
			register.tabIndex = 8;
		}
	}
}