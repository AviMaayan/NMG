<?php
header("Access-Control-Allow-Origin: *");
$user = $_GET["email"];
$password = $_GET["password"];
$usersFolder = "users";
$userExist = false;
$passwordCorrect = false;
if($handle = opendir($usersFolder)) {

	while(false !== ($entry = readdir($handle))) {
		$splits = explode("=",$entry);
		if($user==$splits[0]){
			$userExist = true;
			$passwordInFile = file_get_contents($usersFolder  . '/' . $entry);
			if($password == $passwordInFile){
				$passwordCorrect  = true;
			}
			break;
		}
	}
}
if($userExist){
	if($passwordCorrect) echo "Authenticized";
	else echo "passwordWrong";
}
else echo "noSuchUser";
?>