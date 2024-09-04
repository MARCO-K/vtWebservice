function Get-MD5Hash {
  <#
    .SYNOPSIS
    Calculates the MD5 hash value of a given string.

    .DESCRIPTION
    The Get-MD5Hash function calculates the MD5 hash value of a given string using the MD5.Create() method from the System.Security.Cryptography namespace. It takes a mandatory parameter, InputString, which represents the input string to be hashed. The function returns the MD5 hash value as a string.

    .PARAMETER InputString
    The input string to be hashed.

    .EXAMPLE
    Get-MD5Hash -InputString "Hello, World!"
    # Output: 5eb63bbbe01eeed093cb22bb8f5acdc3

    .NOTES
    This is for internal use only.
    This function requires the System.Security.Cryptography namespace.
    #>

  [CmdletBinding()]
  [OutputType([string])]
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string]$InputString
  )

  begin {
    Write-PSFMessage -Level Verbose -Message "Initializing MD5 hash calculation."
    $md5 = [System.Security.Cryptography.MD5]::Create()
  }

  process {
    try {
      Write-PSFMessage -Level Verbose -Message "Calculating MD5 hash for input string."
      $inputBytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
      $hashBytes = $md5.ComputeHash($inputBytes)
      $hash = [System.BitConverter]::ToString($hashBytes) -replace '-'
      Write-PSFMessage -Level Verbose -Message "MD5 hash calculation completed successfully."
      $hash.ToLower()
    } catch {
      $errorDetails = @{
        Exception = $_.Exception.Message
        Reason    = $_.CategoryInfo.Reason
        Target    = $_.CategoryInfo.TargetName
        Script    = $_.InvocationInfo.ScriptName
        Line      = $_.InvocationInfo.ScriptLineNumber
        Column    = $_.InvocationInfo.OffsetInLine
      }
      Write-PSFMessage -Level Error -Message "An error occurred while calculating the MD5 hash." -ErrorRecord $_
      [PSCustomObject]$errorDetails
    }
  }

  end {
    Write-PSFMessage -Level Verbose -Message "MD5 hash calculation function completed."
    $md5.Dispose()
  }
}