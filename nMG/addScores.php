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
$totalUsersCount = count($totalUsers);
$echoNum = 5; #return 5 users befor and after current user
$userIdx = array_search($user,array_keys($totalUsers));

if($userIdx<$echoNum+1){
	$slice = array_slice($totalUsers,0,2*$echoNum+1);
	$keys = array_keys($slice);
	for ($i=0; $i<2*$echoNum+1; $i++){
		array_push($slice[$keys[$i]],$i+1);
	}
}elseif($userIdx>$totalUsersCount-$echoNum){
	$slice = array_slice($totalUsers, $totalUsersCount- 1 - $echoNum*2, 2*$echoNum+1);
	$keys = array_keys($slice);
	for ($i=0; $i<2*$echoNum+1; $i++){
		array_push($slice[$keys[$i]], $totalUsersCount - $echoNum*2 + $i);
	}
}else{
	$slice = array_slice($totalUsers, $userIdx-5, 2*$echoNum+1);
	$keys = array_keys($slice);
	for ($i=0; $i<2*$echoNum+1; $i++){
		array_push($slice[$keys[$i]], $userIdx-5+$i+1);
	}
}

echo json_encode($slice);



?>