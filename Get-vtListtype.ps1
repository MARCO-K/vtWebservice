function Get-vtListtype
{
  <#
      .SYNOPSIS
      This cmdlet will get all available list types of vtiger.

      .DESCRIPTION   
      This cmdlet will get all available list types of vtiger.

      .PARAMETER uri
      The name of actual uri.

      .PARAMETER contenttype
      The name of actual contenttype.

      .PARAMETER sessionName
      The name of actual sessionName.
      


      .EXAMPLE
      Get-vtListtype -Sessionname $session -uri $uri -sessionName $sessionName

      .OUTPUTS
      The cmdlet will output all available list types.
  #>
  [CmdletBinding()]
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$uri,
    [string]$contenttype = 'application/x-www-form-urlencoded',
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$sessionName
  )
  begin {
    Write-PSFMessage -Level Verbose -Message 'Starting to retrieve list types...'
    $list = @{
      operation   = 'listtypes'
      sessionName = $sessionName
    }
  }
  process {
    try { 
      $result = Invoke-RestMethod -Uri $uri -Method 'GET' -Body $list -ContentType $contenttype
      if($result -and $result.success -eq $true)
      { 
        $listTypes = $result.result.types
      }
      else 
      {
        Write-PSFMessage -Level Warning -Message "Something went wrong... $($result.error.message)"
        $result = $result.error.message
      }
    }
    catch 
    {
      [Management.Automation.ErrorRecord]$e = $_
      $info = [PSCustomObject]@{
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
      }
      $info
    }
  }
  end {
    Write-PSFMessage -Level Verbose -Message 'Output list types...'
    $listTypes
  }
}