function Import-vtRecord
{
  <#
      .SYNOPSIS
      This cmdlet will create a new records in an vtiger module from an object.
      
      .DESCRIPTION   
      This cmdlet will create a new records in an vtiger module from an object..
      
      .PARAMETER uri
      The name of actual uri.
      
      .PARAMETER contenttype
      The name of actual contenttype.
      
      .PARAMETER sessionName
      The name of actual sessionName.
      
      .PARAMETER module
      The name of the module where the new record will be created.
      
      .PARAMETER records
      Theone or more records as object.
      
      .EXAMPLE
      Import-vtRecord -uri $uri -contenttype $contenttype -sessionName $sessionName -module $module -records $object
      
      .OUTPUTS
      The cmdlet will output the resultof the create operation.
  #>
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [string]$contenttype = 'application/x-www-form-urlencoded',
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sessionName,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateScript({
          if( $_ -in (Get-vtListtype -uri $uri -sessionName $sessionName)) 
          {
            return $true
          }
          else 
          {
            throw "$_ is not a valid module name."
          }
    } )]
    [string]$module,
    [parameter(Mandatory,ValueFromPipeline)][ValidateNotNullOrEmpty()][object[]]$records
  )
  begin {
    Write-PSFMessage -Level Verbose -Message "Starting to create $($records.count) new record(s)..."
  }

  process {
    $results =
    foreach($record in $records)
    {
      $record = $record | ConvertTo-Json
      $create = @{
        operation   = 'create'
        sessionName = $sessionName
        element     = $record
        elementType = $module
      }
      try
      {
        Write-PSFMessage -Level Verbose -Message "Trying to create a new record in $module..." 
        $result = Invoke-RestMethod -Uri $uri -Method 'POST' -Body $create -ContentType $contenttype
        if($result -and $result.success -eq $true)
        {
          $result = $result.result
          $result
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
  end{
    Write-PSFMessage -Level Verbose -Message 'Output the newly created record...'
    $results
  }
}