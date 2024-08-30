function Get-vtFieldlist {
  <#
  .SYNOPSIS
  Gets all fields of a vtiger module.

  .DESCRIPTION
  This function retrieves all fields and their basic information (e.g., datatype) for a specified vtiger module.

  .PARAMETER Uri
  The URI of the vtiger API endpoint.

  .PARAMETER ContentType
  The content type for the API request. Defaults to 'application/x-www-form-urlencoded'.

  .PARAMETER SessionName
  The name of the current session.

  .PARAMETER Module
  The name of the vtiger module to retrieve fields for.

  .EXAMPLE
  Get-vtFieldlist -Uri 'https://your.vtiger.com/webservice.php' -SessionName 'YourSessionToken' -Module 'Contacts'

  .OUTPUTS
  An array of PSCustomObjects containing field information (Name, Label, Datatype, Mandatory).
  #>

  [CmdletBinding()]
  [OutputType([PSCustomObject[]])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

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
          return $true
        }
        throw "'$_' is not a valid module name. Valid modules are: $($validModules -join ', ')"
      })]
    [string]$Module
  )

  begin {
    Write-PSFMessage -Level Verbose -Message "Starting to get field list for module '$Module'..."
    $describeParams = @{
      sessionName = $SessionName
      operation   = 'describe'
      elementType = $Module
    }
  }

  process {
    try {
      Write-PSFMessage -Level Verbose -Message "Retrieving field list for module '$Module'..."
      $invokeParams = @{
        Uri         = $Uri
        Method      = 'GET'
        Body        = $describeParams
        ContentType = $ContentType
        ErrorAction = 'Stop'
      }
      $result = Invoke-RestMethod @invokeParams

      if ($result.success -eq $true) {
        Write-PSFMessage -Level Verbose -Message "Successfully retrieved field list for module '$Module'."
        $fieldlist = $result.result.fields | ForEach-Object {
          [PSCustomObject]@{
            Name      = $_.Name
            Label     = $_.label
            Datatype  = $_.type.name
            Mandatory = $_.mandatory
          }
        }
        $fieldlist
      } else {
        $errorMessage = if ($result.error -and $result.error.PSObject.Properties['message']) { 
          $result.error.message 
        } else { 
          "Unknown error occurred" 
        }
        Write-PSFMessage -Level Warning -Message "Failed to retrieve field list. Error: $errorMessage"
        throw $errorMessage
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
      Write-PSFMessage -Level Error -Message "An error occurred while retrieving the field list" -ErrorRecord $_
      throw [PSCustomObject]$errorDetails
    }
  }

  end {
    Write-PSFMessage -Level Verbose -Message "Completed retrieving field list for module '$Module'."
  }
}