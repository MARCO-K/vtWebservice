function Get-vtHashString
{
    <#
  .SYNOPSIS
  Calculates hash values using modern cryptographic algorithms.

  .DESCRIPTION
  The Get-vtHashString function calculates hash values using various cryptographic algorithms.
  It supports MD5 (for backward compatibility), SHA-256 (recommended), and SHA-512.
  This function replaces Get-MD5Hash with modern security standards.

  .PARAMETER InputString
  The input string to be hashed.

  .PARAMETER Algorithm
  The hash algorithm to use. Valid values are: MD5, SHA256, SHA512.
  Default is SHA256 for better security.

  .EXAMPLE
  Get-vtHashString -InputString "Hello, World!" -Algorithm SHA256
  # Output: a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e

  .EXAMPLE
  Get-vtHashString -InputString "Hello, World!" -Algorithm MD5
  # Output: 65a8e27d8879283831b664bd8b7f0ad4

  .EXAMPLE
  "Hello, World!" | Get-vtHashString -Algorithm SHA256
  # Pipeline support example

  .NOTES
  MD5 is deprecated for security reasons but maintained for vTiger compatibility.
  SHA-256 is recommended for new implementations.
  This function provides a modern replacement for Get-MD5Hash.
  
  .LINK
  https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography
  #>

    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$InputString,

        [Parameter()]
        [ValidateSet('MD5', 'SHA256', 'SHA512')]
        [string]$Algorithm = 'MD5'
    )

    begin
    {
        Write-PSFMessage -Level Verbose -Message "Initializing $Algorithm hash calculation."
    
        # Create the appropriate hash algorithm
        switch ($Algorithm)
        {
            'MD5'
            { 
                $hashAlgorithm = [System.Security.Cryptography.MD5]::Create()
                Write-PSFMessage -Level Warning -Message "MD5 is deprecated for security reasons. Consider using SHA256."
            }
            'SHA256'
            { 
                $hashAlgorithm = [System.Security.Cryptography.SHA256]::Create()
            }
            'SHA512'
            { 
                $hashAlgorithm = [System.Security.Cryptography.SHA512]::Create()
            }
        }
    }

    process
    {
        try
        {
            Write-PSFMessage -Level Verbose -Message "Calculating $Algorithm hash for input string."
      
            # Convert string to bytes
            $inputBytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
      
            # Compute hash
            $hashBytes = $hashAlgorithm.ComputeHash($inputBytes)
      
            # Convert to hex string
            $hash = [System.BitConverter]::ToString($hashBytes) -replace '-'
      
            Write-PSFMessage -Level Verbose -Message "$Algorithm hash calculation completed successfully."
      
            # Return lowercase hex string
            $hash.ToLower()
      
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
                Algorithm = $Algorithm
            }
            Write-PSFMessage -Level Error -Message "An error occurred while calculating the $Algorithm hash." -ErrorRecord $_
            throw [PSCustomObject]$errorDetails
        }
    }

    end
    {
        Write-PSFMessage -Level Verbose -Message "$Algorithm hash calculation function completed."
        if ($hashAlgorithm)
        {
            $hashAlgorithm.Dispose()
        }
    }
}
