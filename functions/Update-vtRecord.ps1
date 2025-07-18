function Update-vtRecord
{
  <#
    .SYNOPSIS
    Updates an existing record.
    .DESCRIPTION   
    Updates an existing record using the provided URI, session name, record ID, and record data.
    .PARAMETER Uri
    The URI for the API endpoint.
    .PARAMETER ContentType
    The content type for the request. Defaults to 'application/x-www-form-urlencoded'.
    .PARAMETER SessionName
    The name of the session.
    .PARAMETER RecordId
    The ID of the record to update.
    .PARAMETER Record
    The JSON data for the record update.
    NOTE: The API expects all mandatory fields to be re-stated as part of the element parameter.
    .EXAMPLE
    Update-vtRecord -Uri 'https://api.example.com' -SessionName 'MySession' -RecordId '12345' -Record '{"field1":"value1","field2":"value2"}'
    .OUTPUTS
    Returns the result of the update operation.
    #>
  [CmdletBinding(SupportsShouldProcess)]
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
    [string]$RecordId,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        $_ | ConvertFrom-Json -ErrorAction Stop
        $true
      })]
    [string]$Record
  )
  
  begin
  {
    Write-PSFMessage -Level Verbose -Message "Starting to update record with ID: $RecordId"
    $updateParams = @{
      operation   = 'update'
      sessionName = $SessionName
      element     = $Record
    }
  }

  process
  {
    try
    {
      # ShouldProcess check for record update
      if ($PSCmdlet.ShouldProcess("Record ID: $RecordId", "Update vTiger record"))
      {
        Write-PSFMessage -Level Verbose -Message "Sending update request for record ID: $RecordId"
        $invokeParams = @{
          Uri         = $Uri
          Method      = 'POST'
          Body        = $updateParams
          ContentType = $ContentType
          ErrorAction = 'Stop'
        }
        $result = Invoke-RestMethod @invokeParams

        if ($result.success -eq $true)
        {
          Write-PSFMessage -Level Verbose -Message "Successfully updated record ID: $RecordId"
          # Add custom type to the updated record if it contains record data
          if ($result.result)
          {
            $record = $result.result
            $record.PSObject.TypeNames.Insert(0, 'vtWebservice.Record')
            $result.result = $record
          }
          $result
        }
        else
        {
          $errorMessage = $result.error.message 
          Write-PSFMessage -Level Warning -Message "Failed to update record. Error: $errorMessage"
          $result
        }
      }
      else
      {
        Write-PSFMessage -Level Verbose -Message "Skipped update of record ID: $RecordId (WhatIf or user declined)"
        return [PSCustomObject]@{
          success = $false
          Status  = 'Skipped'
          Message = 'Operation cancelled by user or WhatIf'
        }
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
      Write-PSFMessage -Level Error -Message "An error occurred while updating the record" -ErrorRecord $_
      [PSCustomObject]$errorDetails
    }
  }

  end
  {
    Write-PSFMessage -Level Verbose -Message "Completed update operation for record ID: $RecordId"
  }
}