function Get-vtRetrieverecord
{
  <#
      .SYNOPSIS
      This cmdlet will retrieve one based on its ID.

      .DESCRIPTION   
      This cmdlet will retrieve one based on its ID.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER sessionName
      The name of actual sessionName.
      
      .PARAMETER recordid
      The ID of the specified record.

      .EXAMPLE
      Get-vtRetrieverecord -Sessionname $session -uri $uri -sessionName $sessionName -recordid $recordid

      .OUTPUTS
      The cmdlet will output  one or more records.
  #>
  [CmdletBinding()]
  param(
    [string]$uri,
    [string]$contenttype,
    [string]$sessionName,
    [string]$recordid
  )
  begin {
    $retrieve = @{
      operation   = 'retrieve'
      sessionName = $sessionName
      id          = $recordid
    }
  }
  process {
    $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $retrieve -ContentType $contenttype
  }
  end {
    $result.result
  }
}