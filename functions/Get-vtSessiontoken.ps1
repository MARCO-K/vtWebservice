function Get-vtSessiontoken
{
  <#
      .SYNOPSIS
      This cmdlet will challenge a session token to authenticate a new session.

      .DESCRIPTION   
      This cmdlet will challenge a session token to authenticate a new session.

      .PARAMETER Uri
      The URI of the vTiger API endpoint.

      .PARAMETER ContentType
      The content type for the API request.

      .PARAMETER Username
      The username to acquire the session token.

      .EXAMPLE
      Get-vtSessiontoken -Uri $uri -ContentType $contentType -Username $username

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

  begin
  { 
    Write-PSFMessage -Level Verbose -Message 'Starting to challenge a new sesison token...'
    $challenge = @{
      operation = 'getchallenge'
      username  = $username
    }
  }
  process
  { 
    try
    { 
      Write-PSFMessage -Level Verbose -Message 'Requesting a new session token...'
      $params = @{
        Uri         = $Uri
        Method      = 'Get'
        Body        = $challenge
        ContentType = $ContentType
        ErrorAction = 'Stop'
      }
      $result = Invoke-RestMethod @params

      if ($result.success)
      {
        Write-PSFMessage -Level Verbose -Message 'Successfully obtained session token.'
        $result.result.token
      }
      else
      {
        Write-PSFMessage -Level Warning -Message "Failed to obtain session token: $($result.error.message)"
        throw $result.error.message
      }
    }
    catch
    {
      $errorDetails = @{
        Exception = $_.Exception.Message
        Reason    = $_.CategoryInfo.Reason
        Target    = $_.CategoryInfo.TargetName
        Script    = $_.InvocationInfo.ScriptName
        Line      = $_.InvocationInfo.ScriptLineNumber
        Column    = $_.InvocationInfo.OffsetInLine
      }
      Write-PSFMessage -Level Error -Message "An error occurred while obtaining session token" -ErrorRecord $_
      throw [PSCustomObject]$errorDetails
    }
  }
  end
  {
    Write-PSFMessage -Level Verbose -Message 'Session token request completed.'
  }
}
