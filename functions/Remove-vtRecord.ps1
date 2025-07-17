function Remove-vtRecord
{
  <#
.SYNOPSIS
Removes one or more records from a vtiger module based on their IDs.

.DESCRIPTION
This function removes one or more records from a vtiger module using their unique IDs. It supports pipeline input for batch processing of multiple record IDs.

.PARAMETER Uri
The URI of the vtiger web service.

.PARAMETER ContentType
The content type for the web request. Defaults to 'application/x-www-form-urlencoded'.

.PARAMETER SessionName
The name of the active session for authentication.

.PARAMETER RecordIds
An array of record IDs to be deleted. Supports pipeline input.

.EXAMPLE
Remove-vtRecord -Uri "https://your.vtiger.com/webservice.php" -SessionName "YourSessionToken" -RecordIds "11x1", "11x2"

This example removes two records with IDs "11x1" and "11x2".

.EXAMPLE
"11x3", "11x4" | Remove-vtRecord -Uri "https://your.vtiger.com/webservice.php" -SessionName "YourSessionToken"

This example uses pipeline input to remove records with IDs "11x3" and "11x4".

.OUTPUTS
An array of PSCustomObjects, each containing the ID of the processed record, the status of the operation (Success, Failed, or Error), and any error message if applicable.

.NOTES
Ensure you have an active session and appropriate permissions before using this function.
#>

  [CmdletBinding(SupportsShouldProcess)]
  [OutputType([PSCustomObject[]])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ContentType = 'application/x-www-form-urlencoded',

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$SessionName,

    [Parameter(Mandatory, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string[]]$RecordIds
  )

  begin
  {
    Write-PSFMessage -Level Verbose -Message "Starting to delete record(s)..."
    $results = @()
  }

  process
  {
    foreach ($recordId in $RecordIds)
    {
      try
      {
        # ShouldProcess check for destructive operation
        if ($PSCmdlet.ShouldProcess("Record ID: $recordId", "Remove vTiger Record"))
        {
          Write-PSFMessage -Level Verbose -Message "Attempting to delete record with ID: $recordId"

          $params = @{
            Uri         = $Uri
            Method      = 'Post'
            ContentType = $ContentType
            Body        = @{
              operation   = 'delete'
              sessionName = $SessionName
              id          = $recordId
            }
            ErrorAction = 'Stop'
          }

          $response = Invoke-RestMethod @params

          if ($response.success)
          {
            Write-PSFMessage -Level Verbose -Message "Successfully deleted record with ID: $recordId"
            $results += [PSCustomObject]@{
              ID     = $recordId
              Status = $response.result.status
            }
          }
          else
          {
            Write-PSFMessage -Level Warning -Message "Failed to delete record with ID $recordId : $($response.error.message)"
            $results += [PSCustomObject]@{
              ID     = $recordId
              Status = 'Failed'
              Error  = $response.error.message
            }
          }
        }
        else
        {
          Write-PSFMessage -Level Verbose -Message "Skipped deletion of record with ID: $recordId (WhatIf or user declined)"
          $results += [PSCustomObject]@{
            ID     = $recordId
            Status = 'Skipped'
            Error  = 'Operation cancelled by user or WhatIf'
          }
        }
      }
      catch
      {
        Write-PSFMessage -Level Error -Message "An error occurred while deleting record with ID $recordId : $_"
        $Errormessage = [PSCustomObject]@{
          ID     = $recordId
          Status = 'Error'
          Error  = $_.Exception.Message
        }
        $results += $Errormessage
      }
    }
  }

  end
  {
    Write-PSFMessage -Level Verbose -Message 'Finished processing all records.'
    $results
  }
}