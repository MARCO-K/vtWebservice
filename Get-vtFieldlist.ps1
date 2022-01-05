function Get-vtFieldlist 
{
  <#
      .SYNOPSIS
      This cmdlet will get all fields of a vtiger module.

      .DESCRIPTION   
      This cmdlet will get all fields of a vtiger module.
      It will retrieve all field and their basic informations, e.g datatype.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER sessionName
      The name of actual sessionName.

      .PARAMETER module
      The name of the vtiger module.

      .EXAMPLE
      Get-vtFieldlist -Sessionname $session -module $module

      .OUTPUTS
      The cmdlet will output all fileds as object.
  #>
  param(
    [string]$uri,
    [string]$contenttype,
    [string]$sessionName,
    [string]$module 
  )
  
  begin {
    #describe
    $describe = @{
      sessionName = $sessionName
      operation   = 'describe'
      elementType = $module
    }
    $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $describe -ContentType $contenttype
   
  }
  process {
    $fieldlist = 
    foreach ($field in $result.result.fields)
    {
      [PSCustomObject]@{
        Name      = $field.Name
        Label     = $field.label
        Datatype  = $field.type.name
        Mandatory = $field.mandatory
      }
    }
  }

  end{
    $fieldlist
  }
}