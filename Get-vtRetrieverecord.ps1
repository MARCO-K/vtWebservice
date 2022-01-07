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
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [string]$contenttype = 'application/x-www-form-urlencoded',
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sessionName,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$recordid
  )
  begin {
    Write-PSFMessage -Level Verbose -Message "Starting to retrieve a record for ID: $recordid..."
    $retrieve = @{
      operation   = 'retrieve'
      sessionName = $sessionName
      id          = $recordid
    }
  }
  process {
    try 
    { 
      Write-PSFMessage -Level Verbose -Message 'Retrieving the record...'
      $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $retrieve -ContentType $contenttype
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
      Write-PSFMessage -Level Error -Message 'Something went really wrong...'
    }
  }
  end {
    Write-PSFMessage -Level Verbose -Message 'Output the record...'
    $result
  }
}
