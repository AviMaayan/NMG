<?php
header("Access-Control-Allow-Origin: *");
$dataFile = "/home/maaya0/tmp/Qiaonan/data.txt";
$dataContent = file_get_contents($dataFile);
$totalUsers = array();
if($handle = opendir($dataContent)) {

	while(false !== ($entry = readdir($handle))) {
		$splits = explode("=",$entry);
		if(count($splits)<4) continue; #filter unrelevant filenames
		$totalUsers[$splits[0]] = array(intval($splits[1]),intval($splits[2]));
	}
}

asort($totalUsers);
$totalUsers = array_reverse($totalUsers);

echo json_encode($totalUsers);