function Get-vtListtype {
  <#
  .SYNOPSIS
  Retrieves all available list types from vtiger.

  .DESCRIPTION
  This function retrieves all available list types from the vtiger CRM system using the provided API endpoint.

  .PARAMETER Uri
  The URI of the vtiger API endpoint.

  .PARAMETER ContentType
  The content type for the API request. Defaults to 'application/x-www-form-urlencoded'.

  .PARAMETER SessionName
  The name of the current session.

  .EXAMPLE
  Get-vtListtype -Uri 'https://your.vtiger.com/webservice.php' -SessionName 'YourSessionToken'

  .OUTPUTS
  An array of strings representing the available list types.
  #>

  [CmdletBinding()]
  [OutputType([string[]])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [ValidateNotNullOrEmpty()]
    [string]$ContentType = 'application/x-www-form-urlencoded',

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$SessionName
  )

  begin {
    Write-PSFMessage -Level Verbose -Message 'Starting to retrieve list types...'
    $listParams = @{
      operation   = 'listtypes'
      sessionName = $SessionName
    }
  }

  process {
    try { 
      Write-PSFMessage -Level Verbose -Message 'Sending request to retrieve list types...'
      $invokeParams = @{
        Uri         = $Uri
        Method      = 'GET'
        Body        = $listParams
        ContentType = $ContentType
        ErrorAction = 'Stop'
      }
      $result = Invoke-RestMethod @invokeParams

      if ($result.success -eq $true) { 
        Write-PSFMessage -Level Verbose -Message 'Successfully retrieved list types.'
        $result.result.types
      } else {
        $errorMessage = if ($result.error.PSObject.Properties['message']) { 
          $result.error.message 
        } else { 
          "Unknown error occurred" 
        }
        Write-PSFMessage -Level Warning -Message "Failed to retrieve list types. Error: $errorMessage"
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
      Write-PSFMessage -Level Error -Message "An error occurred while retrieving list types" -ErrorRecord $_
      throw [PSCustomObject]$errorDetails
    }
  }

  end {
    Write-PSFMessage -Level Verbose -Message 'Completed retrieving list types.'
  }
}