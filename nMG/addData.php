<html>
<head>
<title>My first page in addData.</title>
</head>
<body>
 <?php
$doc = new DOMDocument;
$doc->preserveWhiteSpace = false;
$doc->load("nMG_userData.xml"); 

$email=$doc->createElement('email',$_REQUEST["email"]);
$password=$doc->createElement('password',$_REQUEST["password"]);
$totalScore=$doc->createElement('totalScore',$_REQUEST["totalScore"]);
$user=$doc->createElement('user');
$user->appendChild($email);
$user->appendChild($password);
$user->appendChild($totalScore);

$userList=$doc->getElementsByTagName("user");
$uNum=$userList->length;
$i=0;
if($uNum==0)
$doc->documentElement->appendChild($user);
else
{
foreach ($userList as $u)
{
	$i++;
	$t1=(int) $totalScore->nodeValue;
	$t2=(int) $u->lastChild->nodeValue;
	if($t1>$t2)
	{
		$u->parentNode->insertBefore($user,$u);
		break;
	}
	if($i==$uNum)
	{
		$u->parentNode->insertBefore($user,$u->nextSibling);
	}
}
}

$file=fopen("nMG_userData.xml","w");
 fwrite($file,$doc->saveXML());
fclose($file);

?>


</body>
</html> 