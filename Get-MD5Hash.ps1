function Get-MD5Hash
{
  param(
    [string]$tokenstring
  )
  Begin {}
  Process { 
    $md5  = [Security.Cryptography.MD5CryptoServiceProvider]::new()
    $utf8 = [Text.UTF8Encoding]::UTF8
    $bytes= $md5.ComputeHash($utf8.GetBytes($tokenstring))
    $hash = [string]::Concat($bytes.foreach{$_.ToString("x2")}) 
  }
  end {
  $hash
  }

}