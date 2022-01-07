function Remove-vtRecord
{
  <#
      .SYNOPSIS
      This cmdlet will remove one or more records based on its ID.

      .DESCRIPTION   
      This cmdlet will retrieve one based on its ID.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER sessionName
      The name of actual sessionName.
      
      .PARAMETER recordids
      The ID of one or more records.

      .EXAMPLE
      Remove-vtRecord -Sessionname $session -uri $uri -sessionName $sessionName -recordids $records

      .OUTPUTS
      The cmdlet will output the status of the delete operation for each ID.
  #>
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [string]$contenttype = 'application/x-www-form-urlencoded',
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sessionName,
    [parameter(Mandatory,ValueFromPipeline)][ValidateNotNullOrEmpty()][object[]]$recordids
  )
  begin {
    Write-PSFMessage -Level Verbose -Message "Starting to delete $($recordids.count) record(s)..."

  }
  process {
    $results = 
    foreach($recordid in $recordids) 
    { 
      $delete = @{
        operation   = 'delete'
        sessionName = $sessionName
        id          = $recordid
      }
      try 
      { 
        Write-PSFMessage -Level Verbose -Message "Deleting the record for ID: $recordid..."
        $result = Invoke-RestMethod -Uri $uri -Method 'POST' -Body $delete -ContentType $contenttype
        if($result -and $result.success -eq $true) 
        {
          $output = [PSCustomObject]@{
            ID = $recordid
            status = $result.result.status
          }
          $output
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
  }
  end {
    Write-PSFMessage -Level Verbose -Message 'Output the record...'
    $results
  }
}
