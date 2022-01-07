function Get-MD5Hash
{
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
