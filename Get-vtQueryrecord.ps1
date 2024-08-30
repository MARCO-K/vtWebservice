function Get-vtQueryrecord {
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
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$uri,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$contenttype,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$sessionName,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$querystring
  )

  begin {
    Write-PSFMessage -Level Verbose -Message 'Starting to query records...'

    # Basic validation to ensure the querystring contains only allowed characters
    $allowedCharacters = '^[a-zA-Z0-9_\s\.,;''"\(\)\-\+\*\=\<\>\!\&\|\%]+$'
    if (-not ($querystring -match $allowedCharacters)) {
      Write-PSFMessage -Level Error -Message "Invalid characters in querystring: $querystring"
      throw "Invalid querystring"
    }

    $query = @{
      sessionName = $sessionName
      operation   = 'query'
      query       = $querystring
    }
  }

  process {
    try {
      Write-PSFMessage -Level Verbose -Message "Querying records with query string: $querystring"
      $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $query -ContentType $contenttype

      if ($result -and $result.success -eq $true) {
        $result = $result.result
      } elseif ($result.success -eq $false) {
        Write-PSFMessage -Level Warning -Message "Query failed: $($result.error.message)"
        $result = $result.error.message
      } else {
        Write-PSFMessage -Level Error -Message "Unexpected response from the server."
      }
    } catch {
      $errorDetails = @{
        Exception = $_.Exception.Message
        Reason    = $_.CategoryInfo.Reason
        Target    = $_.CategoryInfo.TargetName
        Script    = $_.InvocationInfo.ScriptName
        Line      = $_.InvocationInfo.ScriptLineNumber
        Column    = $_.InvocationInfo.OffsetInLine
      }
      Write-PSFMessage -Level Error -Message "An error occurred: $($info.Exception)" -ErrorRecord $_
      throw [PSCustomObject]$errorDetails
    }
  }

  end {
    Write-PSFMessage -Level Verbose -Message 'Outputting the query records...'
    $result
  }
}