function Get-vtRetrieverecord {
  <#
  .SYNOPSIS
  Retrieves one or more records from vtiger CRM based on record IDs.

  .DESCRIPTION
  This function retrieves one or more records from the vtiger CRM system using the provided record IDs.

  .PARAMETER Uri
  The URI of the vtiger API endpoint.

  .PARAMETER ContentType
  The content type for the API request. Defaults to 'application/x-www-form-urlencoded'.

  .PARAMETER SessionName
  The name of the current session.

  .PARAMETER RecordIds
  An array of record IDs to retrieve.

  .EXAMPLE
  Get-vtRetrieverecord -Uri 'https://your.vtiger.com/webservice.php' -SessionName 'YourSessionToken' -RecordIds '12x34', '12x35'

  .OUTPUTS
  Returns an array of retrieved records.
  #>

  [CmdletBinding()]
  [OutputType([PSCustomObject[]])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [ValidateNotNullOrEmpty()]
    [string]$ContentType = 'application/x-www-form-urlencoded',

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$SessionName,

    [Parameter(Mandatory, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string[]]$RecordIds
  )

  begin {
    Write-PSFMessage -Level Verbose -Message 'Starting to retrieve records...'
  }

  process {
    $result =
    foreach ($recordId in $RecordIds) { 
      $retrieve = @{
        operation   = 'retrieve'
        sessionName = $sessionName
        id          = $recordid
      }

      try { 
        Write-PSFMessage -Level Verbose -Message "Retrieving the record for ID: $recordId..."
        $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $retrieve -ContentType $contenttype

        if ($result.success -eq $true) {
          $result.result
          Write-PSFMessage -Level Verbose -Message "Successfully retrieved record for ID: $recordId"
        } else {
          $errorMessage = if ($result.error.PSObject.Properties['message']) { 
            $result.error.message 
          } else { 
            "Unknown error occurred while retrieving record" 
          }
          Write-PSFMessage -Level Warning -Message "Failed to retrieve record for ID: $recordId. Error: $errorMessage"
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
        Write-PSFMessage -Level Error -Message "An error occurred while retrieving record for ID: $recordId" -ErrorRecord $_
        [PSCustomObject]$errorDetails
      }
    }
  }
  end {
    Write-PSFMessage -Level Verbose -Message 'Output the records...'
    $result
  }
}
