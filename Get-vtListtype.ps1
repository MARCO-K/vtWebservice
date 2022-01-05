function Get-vtListtype
{
  <#
      .SYNOPSIS
      This cmdlet will get all available list types of vtiger.

      .DESCRIPTION   
      This cmdlet will get all available list types of vtiger.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER sessionName
      The name of actual sessionName.
      


      .EXAMPLE
      Get-vtListtype -Sessionname $session -uri $uri -sessionName $sessionName

      .OUTPUTS
      The cmdlet will output all available list types.
  #>
  [CmdletBinding()]
  param(
    [string]$uri,
    [string]$contenttype,
    [string]$sessionName
  )
  begin {

    $list = @{
      operation   = 'listtypes'
      sessionName = $sessionName
    }
  }
  process {
    $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $list -ContentType $contenttype
    $listTypes = $result.result.types
  }
  end {
    $listTypes
  }
}