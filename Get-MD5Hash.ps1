
function Get-MD5Hash
{
  <#
  .SYNOPSIS
  Calculates the MD5 hash value of a given string.

  .DESCRIPTION
  The Get-MD5Hash function calculates the MD5 hash value of a given string using the MD5CryptoServiceProvider class from the System.Security.Cryptography namespace. It takes a mandatory parameter, $tokenstring, which represents the input string to be hashed. The function returns the MD5 hash value as a string.

  .PARAMETER tokenstring
  The input string to be hashed.

  .EXAMPLE
  Get-MD5Hash -tokenstring "Hello, World!"
  5eb63bbbe01eeed093cb22bb8f5acdc3

  .NOTES
  This is for internal use only.
  This function requires the System.Security.Cryptography and System.Text namespaces.
  #>
  param(
    [parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$tokenstring
  )
  Begin {}
  Process {
    try 
    {  
      $md5  = [Security.Cryptography.MD5CryptoServiceProvider]::new()
      $utf8 = [Text.UTF8Encoding]::UTF8
      $bytes = $md5.ComputeHash($utf8.GetBytes($tokenstring))
      $hash = [string]::Concat($bytes.foreach{
          $_.ToString('x2')
      }) 
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
    $hash
  }
}
