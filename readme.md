# vtWebservice
This module will support the work with the vTiger REST API.

## script samples
*** basics ***  

	$uri = 'http://localhost/webservice.php'  
	$username ='webservice'  
	$userKey = 'somekey'  

*** create new session ***

	$contentType = 'application/x-www-form-urlencoded'  
	$token = Get-vtSessiontoken -uri $uri -contenttype $contentType -username $username  
	$accessKey =Get-MD5Hash -tokenstring ($token + $userKey)  
	$sessionname = Get-vtLogin -uri $uri -contenttype $contentType -username $username -accessKey $accessKey  
  
*** do some stuff ***  

  	Get-vtListtype -uri $uri -contenttype $contentType -sessionName $sessionname  
	Get-vtFieldlist -uri $uri -contenttype $contentType -sessionName $sessionName -module 'Services' 
	New-vtRecordEntry -uri $uri -contenttype $contenttype -sessionName $sessionName -module $module -record $record