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
      The JSON data of the for record.

      .EXAMPLE
      New-vtRecordEntry -uri $uri -contenttype $contenttype -sessionName $sessionName -module $module -record $record

      .OUTPUTS
      The cmdlet will output the resultof the create operation.
  #>
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [string]$contenttype = 'application/x-www-form-urlencoded',
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sessionName,
    [parameter(Mandatory)][ValidateSet('Campaigns','Invoice','SalesOrder','PurchaseOrder','Quotes','Vendors','PriceBooks','Calendar','Leads','Accounts','Contacts','Potentials','Products','Documents','Emails','Events','Users','Services','ModComments','Assets','Groups','Currency','DocumentFolders','CompanyDetails','LineItem','Tax','ProductTaxes')]
    [string]$module,
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateScript( {
          if($_ | ConvertFrom-Json) 
          {
            $true 
          }
          else 
          {
            throw "$_ not valid JSON" 
          }
    }  )]
    [string]$record
  )
  begin {
    Write-PSFMessage -Level Verbose -Message 'Starting to create a new record...'
    $create = @{
      operation   = 'create'
      sessionName = $sessionName
      element     = $record
      elementType = $module
    }
  }
  process {
    try
    {
      Write-PSFMessage -Level Verbose -Message "Trying to create a new record in $module..." 
      $result = Invoke-RestMethod -Uri $uri -Method 'POST' -Body $create -ContentType $contenttype
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
  end{
    Write-PSFMessage -Level Verbose -Message 'Output the newly created record...'
    $result
  }
}
