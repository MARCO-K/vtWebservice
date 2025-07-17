function Connect-vtSession
{
    <#
  .SYNOPSIS
  Creates a complete authenticated session for vTiger CRM with integrated workflow.

  .DESCRIPTION
  This function handles the complete vTiger authentication workflow:
  1. Requests a session token from vTiger
  2. Generates MD5 hash of token + user key
  3. Creates authenticated session
  Returns the session name for use in subsequent API calls.

  .PARAMETER Uri
  The URI of the vTiger API endpoint (typically ends with webservice.php).

  .PARAMETER ContentType
  The content type for the API request. Defaults to 'application/x-www-form-urlencoded'.

  .PARAMETER Username
  The vTiger username for authentication.

  .PARAMETER UserAccessKey
  The vTiger user access key (found in user preferences).

  .EXAMPLE
  $session = Connect-vtSession -Uri 'https://your.vtiger.com/webservice.php' -Username 'webservice' -UserAccessKey 'your_access_key'

  .EXAMPLE
  # Using with subsequent operations
  $session = Connect-vtSession -Uri $uri -Username $username -UserAccessKey $userKey
  Get-vtListtype -Uri $uri -SessionName $session

  .OUTPUTS
  Returns the authenticated session name as a string.

  .NOTES
  This function replaces the manual 3-step process:
  - Get-vtSessiontoken
  - Get-vtHashString (replaces Get-MD5Hash)
  - Get-vtLogin
  
  .LINK
  https://wiki.vtiger.com/index.php/Webservices_API_Reference
  #>

    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Uri,

        [Parameter()]
        [ValidateSet('application/x-www-form-urlencoded', 'application/json')]
        [string]$ContentType = 'application/x-www-form-urlencoded',

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$UserAccessKey
    )
    
    begin
    {
        Write-PSFMessage -Level Verbose -Message 'Starting integrated vTiger authentication workflow...'
    }

    process
    {
        try
        {
            # Step 1: Get session token
            Write-PSFMessage -Level Verbose -Message 'Step 1: Requesting session token...'
            $token = Get-vtSessiontoken -Uri $Uri -ContentType $ContentType -Username $Username
      
            if (-not $token)
            {
                throw 'Failed to obtain session token from vTiger'
            }
      
            Write-PSFMessage -Level Verbose -Message 'Session token obtained successfully'

            # Step 2: Generate access key hash
            Write-PSFMessage -Level Verbose -Message 'Step 2: Generating access key hash using MD5...'
            $hashInput = "$token$UserAccessKey"
            $accessKey = Get-vtHashString -InputString $hashInput -Algorithm MD5
            
            if (-not $accessKey)
            {
                throw 'Failed to generate access key hash using MD5'
            }
      
            Write-PSFMessage -Level Verbose -Message 'Access key hash generated successfully'

            # Step 3: Create authenticated session
            Write-PSFMessage -Level Verbose -Message 'Step 3: Creating authenticated session...'
            $sessionName = Get-vtLogin -Uri $Uri -ContentType $ContentType -Username $Username -AccessKey $accessKey
      
            if (-not $sessionName)
            {
                throw 'Failed to create authenticated session'
            }
      
            Write-PSFMessage -Level Verbose -Message "Authenticated session created successfully: $sessionName"
      
            # Return session name for use in subsequent calls
            return $sessionName

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
                Step      = switch ($_.InvocationInfo.ScriptLineNumber)
                {
                    { $_ -le 60 } { 'Token Request' }
                    { $_ -le 70 } { 'Hash Generation' }
                    default { 'Session Creation' }
                }
            }
      
            Write-PSFMessage -Level Error -Message "Authentication workflow failed at step: $($errorDetails.Step)" -ErrorRecord $_
            throw [PSCustomObject]$errorDetails
        }
    }

    end
    {
        Write-PSFMessage -Level Verbose -Message 'Authentication workflow completed'
    }
}
