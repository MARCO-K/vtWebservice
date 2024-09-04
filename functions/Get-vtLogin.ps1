function Get-vtLogin {
  <#
  .SYNOPSIS
  Logs in and creates a new session for vtiger CRM.

  .DESCRIPTION
  This function logs in to the vtiger CRM system and creates a new session using the provided credentials.

  .PARAMETER Uri
  The URI of the vtiger API endpoint.

  .PARAMETER ContentType
  The content type for the API request. Defaults to 'application/x-www-form-urlencoded'.

  .PARAMETER Username
  The username to acquire the session token.

  .PARAMETER AccessKey
  The access key to create the new session.

  .EXAMPLE
  Get-vtLogin -Uri 'https://your.vtiger.com/webservice.php' -Username 'your_username' -AccessKey 'your_access_key'

  .OUTPUTS
  Returns the new session token as a string.
  #>

  [CmdletBinding()]
  [OutputType([string])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [ValidateNotNullOrEmpty()]
    [string]$ContentType = 'application/x-www-form-urlencoded',

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Username,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$AccessKey
  )

  begin { 
    Write-PSFMessage -Level Verbose -Message 'Starting login process...'
    $loginParams = @{
      operation = 'login'
      username  = $Username
      accessKey = $AccessKey
    }
  }

  process {
    try {
      Write-PSFMessage -Level Verbose -Message 'Sending login request...' 
      $invokeParams = @{
        Uri         = $Uri
        Method      = 'POST'
        Body        = $loginParams
        ContentType = $ContentType
        ErrorAction = 'Stop'
      }
      $result = Invoke-RestMethod @invokeParams

      if ($result.success -eq $true) {
        Write-PSFMessage -Level Verbose -Message 'Login successful. Session created.'
        $result.result.sessionName
      } else {
        $errorMessage = if ($result.error.PSObject.Properties['message']) { 
          $result.error.message 
        } else { 
          "Unknown error occurred during login" 
        }
        Write-PSFMessage -Level Warning -Message "Login failed. Error: $errorMessage"
        throw $errorMessage
      }
    } catch {
      $errorDetails = @{
        Exception = $_.Exception.Message
        Reason    = $_.CategoryInfo.Reason
        Target    = $_.CategoryInfo.TargetName
        Script    = $_.InvocationInfo.ScriptName
        Line      = $_.InvocationInfo.ScriptLineNumber
        Column    = $_.InvocationInfo.OffsetInLine
      }
      Write-PSFMessage -Level Error -Message "An error occurred during the login process" -ErrorRecord $_
      throw [PSCustomObject]$errorDetails
    }
  }

  end {
    Write-PSFMessage -Level Verbose -Message 'Login process completed.'
  }
}