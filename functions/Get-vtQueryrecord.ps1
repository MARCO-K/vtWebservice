function Get-vtQueryrecord
{
  <#
    .SYNOPSIS
    Retrieves one or more records matching filtering field conditions from vtiger CRM.

    .DESCRIPTION
    This function queries the vtiger CRM system and retrieves records that match the specified filtering conditions.

    .PARAMETER Uri
    The URI of the vtiger API endpoint.

    .PARAMETER ContentType
    The content type for the API request.

    .PARAMETER SessionName
    The name of the current session.

    .PARAMETER QueryString
    The filtering conditions for the query.

    .EXAMPLE
    Get-vtQueryrecord -Uri 'https://your.vtiger.com/webservice.php' -ContentType 'application/x-www-form-urlencoded' -SessionName 'YourSessionToken' -QueryString 'SELECT * FROM Contacts;'

    .OUTPUTS
    Returns one or more records matching the query conditions.
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

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$QueryString
  )

  begin
  {
    Write-PSFMessage -Level Verbose -Message 'Starting to query records...'
    $queryParams = @{
      sessionName = $SessionName
      operation   = 'query'
      query       = $QueryString
    }
  }

  process
  {
    try
    {
      Write-PSFMessage -Level Verbose -Message "Querying records with: $QueryString"
      $invokeParams = @{
        Uri         = $Uri
        Method      = 'GET'
        Body        = $queryParams
        ContentType = $ContentType
        ErrorAction = 'Stop'
      }
      $result = Invoke-RestMethod @invokeParams

      if ($result.success -eq $true)
      {
        Write-PSFMessage -Level Verbose -Message 'Query executed successfully.'
        # Add custom type to each record
        $records = $result.result | ForEach-Object {
          $record = $_
          $record.PSObject.TypeNames.Insert(0, 'vtWebservice.Record')
          $record
        }
        $records
      }
      elseif ($result.success -eq $false)
      {
        $errorMessage = if ($result.error.PSObject.Properties['message'])
        { 
          $result.error.message 
        }
        else
        { 
          "Unknown error occurred during query" 
        }
        Write-PSFMessage -Level Warning -Message "Query failed. Error: $errorMessage"
        throw $errorMessage
      }
      else
      {
        throw "Unexpected response from server"
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
      Write-PSFMessage -Level Error -Message "An error occurred during the query process" -ErrorRecord $_
      throw [PSCustomObject]$errorDetails
    }
  }

  end
  {
    Write-PSFMessage -Level Verbose -Message 'Query process completed.'
  }
}