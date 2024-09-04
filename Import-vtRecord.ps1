function Import-vtRecord {
  <#
      .SYNOPSIS
      This cmdlet will create a new records in an vtiger module from an object.
      
      .DESCRIPTION   
      This cmdlet will create a new records in an vtiger module from an object..
      
      .PARAMETER uri
      The name of actual uri.
      
      .PARAMETER contenttype
      The name of actual contenttype.
      
      .PARAMETER sessionName
      The name of actual sessionName.
      
      .PARAMETER module
      The name of the module where the new record will be created.
      
      .PARAMETER records
      One or more records as object.
      
      .EXAMPLE
      Import-vtRecord -uri $uri -contenttype $contenttype -sessionName $sessionName -module $module -records $object
      
      .OUTPUTS
      The cmdlet will output the resultof the create operation.
  #>

  [CmdletBinding()]
  [OutputType([PSCustomObject[]])]
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
          throw "$_ is not a valid module name. Valid modules are: $($validModules -join ', ')"
        }
      })]
    [string]$Module,

    [Parameter(Mandatory, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [object[]]$Records
  )
  begin {
    Write-PSFMessage -Level Verbose -Message "Starting to create $($records.count) new record(s)..."
    $results = @()

  }

  process {
    $results =
    foreach ($record in $records) {
      $create = @{
        operation   = 'create'
        sessionName = $sessionName
        element     = $record | ConvertTo-Json
        elementType = $module
      }
      try {
        Write-PSFMessage -Level Verbose -Message "Attempting to create a new record in $Module..."
        $result = Invoke-RestMethod -Uri $uri -Method 'POST' -Body $create -ContentType $contenttype
        
        if ($result.success) {
          Write-PSFMessage -Level Verbose -Message "Successfully created a new record in $Module."
          $response.result
        } else {
          Write-PSFMessage -Level Warning -Message "Something went wrong... $($result.error.message)"
          $result.error.message
        }
      } catch {
        Write-PSFMessage -Level Error -Message "An error occurred while creating a record: $_"
        $errorDetails = @{
          Exception = $_.Exception.Message
          Reason    = $_.CategoryInfo.Reason
          Target    = $_.CategoryInfo.TargetName
          Script    = $_.InvocationInfo.ScriptName
          Line      = $_.InvocationInfo.ScriptLineNumber
          Column    = $_.InvocationInfo.OffsetInLine
        }
        [PSCustomObject]$errorDetails 
      }
    }
  }
  end {
    Write-PSFMessage -Level Verbose -Message 'Output the newly created record...'
    $results
  }
}