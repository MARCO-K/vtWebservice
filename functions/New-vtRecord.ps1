function New-vtRecord
{
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
      A PowerShell object (e.g., a hashtable or PSCustomObject) containing the record data. The function will convert this to JSON automatically.
      .EXAMPLE
      $newContact = @{
          lastname = 'Doe'
          firstname = 'John'
          email = 'john.doe@example.com'
      }
      New-vtRecord -Uri $uri -SessionName $sessionName -Module 'Contacts' -Record $newContact
      .OUTPUTS
      The cmdlet will output the resultof the create operation.
  #>
  [CmdletBinding(SupportsShouldProcess)]
  [OutputType([PSCustomObject])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [Parameter()]
    [ValidateSet('application/x-www-form-urlencoded', 'application/json')]
    [string]$ContentType = 'application/x-www-form-urlencoded',

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$SessionName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
        $validModules = Get-vtValidModules -Uri $Uri -SessionName $SessionName
        if ($_ -in $validModules)
        {
          $true
        }
        else
        {
          throw "Invalid module name: $_. Valid modules are: $($validModules -join ', ')"
        }
      })]
    [string]$Module,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [object]$Record
  )

  begin
  {
    Write-PSFMessage -Level Verbose -Message 'Starting to create a new record...'
  }

  process
  {
    try
    {
      # ShouldProcess check for record creation
      if ($PSCmdlet.ShouldProcess("Module: $Module", "Create new vTiger record"))
      {
        Write-PSFMessage -Level Verbose -Message "Attempting to create a new record in $Module..."

        $params = @{
          Uri         = $Uri
          Method      = 'Post'
          ContentType = $ContentType
          Body        = @{
            operation   = 'create'
            sessionName = $SessionName
            element     = $Record | ConvertTo-Json
            elementType = $Module
          }
          ErrorAction = 'Stop'
        }

        $response = Invoke-RestMethod @params

        if ($response.success)
        {
          Write-PSFMessage -Level Verbose -Message "Successfully created a new record in $Module."
          # Add custom type to the created record
          $record = $response.result
          $record.PSObject.TypeNames.Insert(0, 'vtWebservice.Record')
          $record
        }
        else
        {
          Write-PSFMessage -Level Warning -Message "Failed to create record: $($response.error.message)"
          throw $response.error.message
        }
      }
      else
      {
        Write-PSFMessage -Level Verbose -Message "Skipped creation of record in $Module (WhatIf or user declined)"
        return [PSCustomObject]@{
          Status  = 'Skipped'
          Message = 'Operation cancelled by user or WhatIf'
        }
      }
    }
    catch
    {
      $errorDetails = @{
        Exception = $_.Exception.Message
        Reason    = $_.CategoryInfo.Reason
        Target    = $_.CategoryInfo.TargetName
        Script    = $_.InvocationInfo.ScriptName
        Line      = $_.InvocationInfo.ScriptLineNumber
        Column    = $_.InvocationInfo.OffsetInLine
      }
      Write-PSFMessage -Level Error -Message "An error occurred while creating a record." -ErrorRecord $_
      throw [PSCustomObject]$errorDetails
    }
  }

  end
  {
    Write-PSFMessage -Level Verbose -Message 'Finished processing New-vtRecord.'
  }
}