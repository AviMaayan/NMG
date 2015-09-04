<html>
<head>
<title>My first page in removedata.</title>
</head>
<body>
 <?php
 $doc = new DOMDocument;
 $doc->preserveWhiteSpace = false;
$doc->load("nMG_userData.xml"); 
 foreach ($doc->getElementsByTagName('user') as $u)
 {
   if($u->firstChild->nodeValue==$_REQUEST["email"]) 
   {
     $u->parentNode->removeChild($u);
	}
 }
 
 $file=fopen("nMG_userData.xml","w");
 fwrite($file,$doc->saveXML());
fclose($file);

?>


</body>
</html> 