﻿function Get-vtLogin 
{
  <#
      .SYNOPSIS
      This cmdlet will login and create a new session.

      .DESCRIPTION   
      This cmdlet will login and create a new session.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER username
      The username to aquire the session token.

      .PARAMETER accessKey
      The accessKey to create the new session.


      .EXAMPLE
      Get-vtLogin -Sessionname $session -uri $uri -accessKey $accessKey

      .OUTPUTS
      The cmdlet will output a new session token as string.
  #>
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$contenttype,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$username,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$accessKey
  )
  begin { 
    $login = @{
      operation = 'login'
      username  = $username
      accessKey = $accessKey
    }
  }
  process {
    $result = Invoke-RestMethod -Uri $uri -Method 'POST' -Body $login -ContentType $contenttype
    if($result) { 
      $sessionName = $result.result.sessionName
    }
  }
  end {
    $sessionName
  }
}