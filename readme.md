# vtWebservice
This module will support the work with the vTiger REST API.

## script samples
	$uri = 'http://localhost/webservice.php'  
	$username ='webservice'  
	$userKey = 'somekey'  

<<<<<<< HEAD
*** create new session ***

	$contentType = 'application/x-www-form-urlencoded'  
	$token = Get-vtSessiontoken -uri $uri -contenttype $contentType -username $username  
	$accessKey =Get-MD5Hash -tokenstring ($token + $userKey)  
	$sessionname = Get-vtLogin -uri $uri -contenttype $contentType -username $username -accessKey $accessKey  

    Get-vtListtype -uri $uri -contenttype $contentType -sessionName $sessionname  
=======
  #create new session
  
	$contentType = 'application/x-www-form-urlencoded'  
	$token = Get-vtSessiontoken -uri $uri -contenttype $contentType -username $username  
	$accessKey =Get-MD5Hash -tokenstring ($token + $userKey)  
	$sessionname = Get-vtLogin -uri $uri -contenttype $contentType -username $username -accessKey $accessKey  

  	Get-vtListtype -uri $uri -contenttype $contentType -sessionName $sessionname  
>>>>>>> e27f2001a3066f95576cc40779d4f0b0b885ff0c
	Get-vtFieldlist -uri $uri -contenttype $contentType -sessionName $sessionName -module 'Services' 
