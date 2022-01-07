function Get-vtLogin 
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
    [string]$contenttype = 'application/x-www-form-urlencoded',
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$username,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$accessKey
  )
  begin { 
    Write-PSFMessage -Level Verbose -Message 'Starting to login ...'
    $login = @{
      operation = 'login'
      username  = $username
      accessKey = $accessKey
    }
  }
  process {
    try 
    {
      Write-PSFMessage -Level Verbose -Message 'Trying to login...' 
      $result = Invoke-RestMethod -Uri $uri -Method 'POST' -Body $login -ContentType $contenttype
      if($result -and $result.success -eq $true) 
      {
        $sessionName = $result.result.sessionName
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
    Write-PSFMessage -Level Verbose -Message 'Output the new session name...'
    $sessionName
  }
}
