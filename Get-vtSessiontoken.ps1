﻿function Get-vtSessiontoken 
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
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [string]$contenttype = 'application/x-www-form-urlencoded',
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$username
  )
  begin { 
    Write-PSFMessage -Level Verbose -Message 'Starting to challenge a new sesison token...'
    $challenge = @{
      operation = 'getchallenge'
      username  = $username
    }
  }
  process { 
    try 
    { 
      Write-PSFMessage -Level Verbose -Message 'Requesting a new sesison token...'
      $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $challenge -ContentType $contenttype
      if($result -and $result.success -eq $true) 
      {
        $token = $result.result.token
      }
      else 
      {
        Write-PSFMessage -Level Warning -Message "Something went wrong... $($result.error.message)"
        $result = $result.error.message
      }
    }
    catch 
    {
      [Management.Automation.ErrorRecord]$e = $_
      $info = [PSCustomObject]@{
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
      }
      $info
    }
  }
  end {
    Write-PSFMessage -Level Verbose -Message 'Output the new token...'
    $token
  }
}
