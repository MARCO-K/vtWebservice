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
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$contenttype,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sessionName,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$querystring
  )
  begin {
    Write-PSFMessage -Level Verbose -Message 'Starting to query records...'
    $query = @{
      sessionName = $sessionName
      operation   = 'query'
      query       = $querystring
    }
  }
  process {
    try 
    { 
      Write-PSFMessage -Level Verbose -Message "Query records... $querystring"
      $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $query -ContentType $contenttype
      if($result -and $result.success -eq $true) 
      {
        $result = $result.result
      }
      elseif($result.success -eq $false) 
      {
        Write-PSFMessage -Level Warning -Message "Something went wrong... $($result.error.message)"
        $result = $result.error.message
      }
      else 
      {
        Write-PSFMessage -Level Error -Message "Something went wrong... $($result.error.message)"
      } 
    }
    catch 
    {
      Write-PSFMessage -Level Error -Message 'Something went really wrong...'
    } 
  }
  end {
    Write-PSFMessage -Level Verbose -Message 'Output the query records...'
    $result
  }
}
