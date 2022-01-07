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
    [string]$module 
  )
  
  begin {
    Write-PSFMessage -Level Verbose -Message "Starting to get a field list for module $module..."
    $describe = @{
      sessionName = $sessionName
      operation   = 'describe'
      elementType = $module
    }
  }
  process {
    try 
    {
      Write-PSFMessage -Level Verbose -Message 'Retrieving field list...'
      $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $describe -ContentType $contenttype
      if($result -and $result.success -eq $true) 
      { 
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
    Write-PSFMessage -Level Verbose -Message 'Output the field list...'
    $fieldlist
  }
}
