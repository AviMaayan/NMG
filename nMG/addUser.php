<?php
header("Access-Control-Allow-Origin: *");
$user = $_GET["email"];
$password = $_GET["password"];
$usersFolder = "users";
$emailRegistered = false;
if($handle = opendir($usersFolder)) {

	while(false !== ($entry = readdir($handle))) {
		$splits = explode("=",$entry);
		if($user==$splits[0]){
			$emailRegistered = true;
			break;
		}
	}
}

if($emailRegistered) echo "emailRegistered";
else{
	$WriteFlag = file_put_contents($usersFolder . "/" . $user . "=0=0=.txt", $password);
	if(false === $WriteFlag) echo "FailToWrite";
	else echo "added";
}

?>