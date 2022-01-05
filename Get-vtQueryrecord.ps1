function Get-vtQueryrecord
{
  <#
      .SYNOPSIS
      This cmdlet will retrieve one or more records matching filtering field conditions.

      .DESCRIPTION   
      This cmdlet will retrieve one or more records matching filtering field conditions.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER sessionName
      The name of actual sessionName.
      
      .PARAMETER querystring
      The filtering conditions for the query.

      .EXAMPLE
      Get-vtQueryrecord -Sessionname $session -uri $uri -sessionName $sessionName -querystring $querystring

      .OUTPUTS
      The cmdlet will output  one or more records.
  #>
  [CmdletBinding()]
  param(
    [string]$uri,
    [string]$contenttype,
    [string]$sessionName,
    [string]$querystring
  )
  begin {

    $query = @{
      sessionName = $sessionName
      operation   = 'query'
      query       = $querystring
    }
  }
  process {
    $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $query -ContentType $contenttype
    $result = $result.result 
  }
  end {
    $result
  }
}