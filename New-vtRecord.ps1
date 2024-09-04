function New-vtRecord {
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
      The JSON data of the for record.
      .EXAMPLE
      New-vtRecordEntry -uri $uri -contenttype $contenttype -sessionName $sessionName -module $module -record $record
      .OUTPUTS
      The cmdlet will output the resultof the create operation.
  #>
  [CmdletBinding()]
  [OutputType([PSCustomObject])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ContentType = 'application/x-www-form-urlencoded',

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$SessionName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        $validModules = Get-vtListtype -Uri $Uri -SessionName $SessionName
        if ($_ -in $validModules) {
          $true
        } else {
          throw "Invalid module name: $_. Valid modules are: $($validModules -join ', ')"
        }
      })]
    [string]$Module,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        try {
          $null = $_ | ConvertFrom-Json
          $true
        } catch {
          throw "Invalid JSON: $_"
        }
      })]
    [string]$Record
  )

  begin {
    Write-PSFMessage -Level Verbose -Message 'Starting to create a new record...'
  }

  process {
    try {
      Write-PSFMessage -Level Verbose -Message "Attempting to create a new record in $Module..."

      $params = @{
        Uri         = $Uri
        Method      = 'Post'
        ContentType = $ContentType
        Body        = @{
          operation   = 'create'
          sessionName = $SessionName
          element     = $Record
          elementType = $Module
        }
        ErrorAction = 'Stop'
      }

      $response = Invoke-RestMethod @params

      if ($response.success) {
        Write-PSFMessage -Level Verbose -Message "Successfully created a new record in $Module."
        $response.result
      } else {
        Write-PSFMessage -Level Warning -Message "Failed to create record: $($response.error.message)"
        throw $response.error.message
      }
    } catch {
      Write-PSFMessage -Level Error -Message "An error occurred while creating a record: $_"
      throw
    }
  }

  end {
    Write-PSFMessage -Level Verbose -Message 'Finished processing New-vtRecord.'
  }
}