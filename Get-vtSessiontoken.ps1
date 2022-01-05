function Get-vtSessiontoken 
{
  <#
      .SYNOPSIS
      This cmdlet will challenge a session token to authenticate a new session.

      .DESCRIPTION   
      This cmdlet will challenge a session token to authenticate a new session.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER username
      The username to aquire the session token.


      .EXAMPLE
      Get-vtSessiontoken -Sessionname $session -uri $uri -username $username

      .OUTPUTS
      The cmdlet will output a new session token as string.
  #>
  [CmdletBinding()]
  param(
    [string]$uri,
    [string]$contenttype,
    [string]$username
  )
  begin { 
    $challenge = @{
      operation = 'getchallenge'
      username  = $username
    }
  }
  process { 
    $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $challenge -ContentType $contenttype
    if($result) {
      $token = $result.result.token
    }
  }
  end {
    $token
  }
}