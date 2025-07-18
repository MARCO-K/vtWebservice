function Get-vtValidModules
{
  <#
  .SYNOPSIS
  Gets valid vTiger modules with caching support for improved performance.
  
  .DESCRIPTION
  This helper function retrieves valid vTiger modules and caches them to improve performance
  for parameter validation. It supports cache invalidation and automatic refresh.
  
  .PARAMETER Uri
  The URI of the vTiger web service.
  
  .PARAMETER SessionName
  The name of the active session.
  
  .PARAMETER NoCache
  Switch to bypass cache and force a fresh API call.
  
  .PARAMETER CacheTimeout
  Cache timeout in minutes. Default is 30 minutes.
  
  .OUTPUTS
  Array of valid module names.
  #>
  
  [CmdletBinding()]
  [OutputType([string[]])]
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$SessionName,

    [Parameter()]
    [switch]$NoCache,

    [Parameter()]
    [int]$CacheTimeout = 30
  )

  # Initialize cache if it doesn't exist
  if (-not $script:ModuleCache)
  {
    $script:ModuleCache = @{}
  }

  $cacheKey = "$Uri-$SessionName"
  $now = Get-Date

  # Check if we have valid cached data
  if (-not $NoCache -and $script:ModuleCache.ContainsKey($cacheKey))
  {
    $cachedData = $script:ModuleCache[$cacheKey]
    if ($cachedData.Timestamp -and (($now - $cachedData.Timestamp).TotalMinutes -lt $CacheTimeout))
    {
      Write-PSFMessage -Level Verbose -Message "Returning cached module list (age: $([math]::Round(($now - $cachedData.Timestamp).TotalMinutes, 1)) minutes)"
      return $cachedData.Modules
    }
  }

  try
  {
    Write-PSFMessage -Level Verbose -Message "Fetching fresh module list from API"
    $modules = Get-vtListtype -Uri $Uri -SessionName $SessionName -ContentType 'application/x-www-form-urlencoded'
    
    # Cache the result
    $script:ModuleCache[$cacheKey] = @{
      Modules   = $modules
      Timestamp = $now
    }
    
    return $modules
  }
  catch
  {
    Write-PSFMessage -Level Warning -Message "Failed to retrieve module list: $($_.Exception.Message)"
    # Return cached data if available, even if expired
    if ($script:ModuleCache.ContainsKey($cacheKey))
    {
      Write-PSFMessage -Level Warning -Message "Using expired cached module list due to API failure"
      return $script:ModuleCache[$cacheKey].Modules
    }
    throw
  }
}


