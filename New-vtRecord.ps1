function New-vtRecord
{
  <#
      .SYNOPSIS
      This cmdlet will create a new record in an vtiger module.

      .DESCRIPTION   
      This cmdlet will create a new record in an vtiger module.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER sessionName
      The name of actual sessionName.
      
      .PARAMETER module
      The name of the module where the new record will be created.

      .PARAMETER record
      The JSOn data of the for record.

      .EXAMPLE
      New-vtRecordEntry -uri $uri -contenttype $contenttype -sessionName $sessionName -module $module -record $record

      .OUTPUTS
      The cmdlet will output the resultof the create operation.
  #>
  [CmdletBinding()]
  param(
    [string]$uri,
    [string]$contenttype,
    [string]$sessionName,
    [string]$module,
    [string]$record
  )
  begin {
    $create = @{
      operation='create'
      sessionName=$sessionName        
      element=$record
      elementType=$module
    }
  }
  process {
    try{
      $result = Invoke-RestMethod -Uri $URI -Method 'POST' -Body $create -ContentType $contenttype
    }
    catch {
    }
  }
  end{
    $result
    }
}