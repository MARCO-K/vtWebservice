function Get-vtSessiontoken {
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
  [OutputType([string])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ContentType = 'application/x-www-form-urlencoded',

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Username
  )

  begin { 
    Write-PSFMessage -Level Verbose -Message 'Starting to challenge a new sesison token...'
    $challenge = @{
      operation = 'getchallenge'
      username  = $username
    }
  }
  process { 
    try { 
      Write-PSFMessage -Level Verbose -Message 'Requesting a new session token...'
      $params = @{
        Uri         = $Uri
        Method      = 'Get'
        Body        = $challenge
        ContentType = $ContentType
        ErrorAction = 'Stop'
      }
      $result = Invoke-RestMethod @params

      if ($result.success) {
        Write-PSFMessage -Level Verbose -Message 'Successfully obtained session token.'
        $result.result.token
      } else {
        Write-PSFMessage -Level Warning -Message "Failed to obtain session token: $($result.error.message)"
        throw $result.error.message
      }
    } catch {
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
  }
}
