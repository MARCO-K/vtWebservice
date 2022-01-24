function Update-vtRecord
{
  <#
      .SYNOPSIS
      This cmdlet will update an existing record.
      .DESCRIPTION   
      This cmdlet will update an existing record.
      .PARAMETER uri
      The name of actual uri.
      .PARAMETER contenttype
      The name of actual contenttype.
      .PARAMETER sessionName
      The name of actual sessionName.
      .PARAMETER recordid
      The ID of one record.
      .PARAMETER record
      The JSON data of the for record.
      NOTE: The API expects all the mandatory fields be re-stated as part of the element parameter.
      .EXAMPLE
      Update-vtRecord -uri $uri -sessionName $sessionName -recordid $id -record $record
      .OUTPUTS
      The cmdlet will output the resultof the create operation.
  #>
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [string]$contenttype = 'application/x-www-form-urlencoded',
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sessionName,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$recordid,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateScript( {
          if($_ | ConvertFrom-Json) 
          {
            $true
          }
          else 
          {
            throw "$_ not valid JSON"
          }
    }  )]
    [string]$record
  )
  
  begin {
    Write-PSFMessage -Level Verbose -Message "Starting to update a record..."
    $update = @{
      operation   = 'update'
      sessionName = $sessionName
      element     = $record
    }
  }
  process {
    try
    {
      Write-PSFMessage -Level Verbose -Message  "Updating the record for ID: $recordid..."
      $result = Invoke-RestMethod -Uri $uri -Method 'POST' -Body $update -ContentType $contenttype
      if($result -and $result.success -eq $true)
      {
        $result = $result.result
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
  end{
    Write-PSFMessage -Level Verbose -Message 'Output the updated record...'
    $result
  }
}