<?php
header("Access-Control-Allow-Origin: *");
#add scores and return current ranks.
$user = $_GET["email"];
$scores = intval($_GET["scores"]);
$usersFolder = "users";
$totalUsers = array();
if($handle = opendir($usersFolder)) {

	while(false !== ($entry = readdir($handle))) {
		$splits = explode("=",$entry);
		if(count($splits)<4) continue;
		$totalUsers[$splits[0]] = array(intval($splits[1]),intval($splits[2]));
	}
}

$currentUserOldData = $totalUsers[$user];
$currentUserOldFilePath = $usersFolder . "/" . $user . "=" . 
 strval($currentUserOldData[0]) . "=" . $currentUserOldData[1] . "=" . ".txt";
$currentUserUpdatedData = array($currentUserOldData[0]+$scores, 
	$currentUserOldData[1]+1);
$currentUserUpdatedFilePath = $usersFolder . "/" . $user . "=" . 
 strval($currentUserUpdatedData[0]) . "=" . $currentUserUpdatedData[1] . "=" . ".txt";
rename($currentUserOldFilePath,$currentUserUpdatedFilePath);
$totalUsers[$user] = $currentUserUpdatedData;

asort($totalUsers);
$totalUsers = array_reverse($totalUsers);
$topNum = 10;
$topUsers = array_slice($totalUsers, 0, $topNum);
if (!array_key_exists($user, $topUsers)){
	// index from 0 so rank plus 1
	$currentUserRank = array_search($user,array_keys($totalUsers)) + 1;
	array_unshift($topUsers, array($user=>array($currentUserUpdatedData[0],
		$currentUserUpdatedData[1],$currentUserRank)));
}


echo json_encode($topUsers);



?>