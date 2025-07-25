﻿
#
# Module Manifest for Module 'vtwebservice.psd1
#
# This manifest file is a PowerShell hashtable with all technical requirements for this module
# This module was autogenerated by ISESteroids (http://www.isesteroids.com)
#
# Generated: 2022-01-07
#

@{

    # Module Loader File
    RootModule             = 'vtWebservice.psm1'

    # Version Number
    ModuleVersion          = '2.0'

    # Unique Module ID
    GUID                   = '05e11f47-4de3-4386-81c4-08d4457a4590'

    # Module Author
    Author                 = 'Marco Kleinert'

    # Company
    CompanyName            = 'Netz-Weise.de'

    # Copyright
    Copyright              = '(c) 2022 Marco Kleinert. All rights reserved.'

    # Module Description
    Description            = 'This module will support the work with the vTiger REST API.'

    # Minimum PowerShell Version Required
    PowerShellVersion      = '5.1'

    # Name of Required PowerShell Host
    PowerShellHostName     = ''

    # Minimum Host Version Required
    PowerShellHostVersion  = ''

    # Minimum .NET Framework-Version
    DotNetFrameworkVersion = ''

    # Minimum CLR (Common Language Runtime) Version
    CLRVersion             = ''

    # Processor Architecture Required (X86, Amd64, IA64)
    ProcessorArchitecture  = ''

    # Required Modules (will load before this module loads)
    RequiredModules        = @()

    # Required Assemblies
    RequiredAssemblies     = @()

    # PowerShell Scripts (.ps1) that need to be executed before this module loads
    ScriptsToProcess       = @()

    # Type files (.ps1xml) that need to be loaded when this module loads
    TypesToProcess         = @()

    # Format files (.ps1xml) that need to be loaded when this module loads
    FormatsToProcess       = @()

    # 
    NestedModules          = @()

    # List of exportable functions
    FunctionsToExport      = @(
        'Connect-vtSession',
        'Get-vtSessiontoken',
        'Get-vtHashString',
        'Get-vtValidModules',
        'Get-vtLogin',
        'Get-vtListtype',
        'Get-vtFieldlist',
        'Get-vtQueryrecord',
        'Get-vtRetrieverecord',
        'New-vtRecord',
        'Update-vtRecord',
        'Remove-vtRecord',
        'Import-vtRecord'
    )

    # List of exportable cmdlets
    CmdletsToExport        = @()

    # List of exportable variables
    VariablesToExport      = @()

    # List of exportable aliases
    AliasesToExport        = @()

    # List of all modules contained in this module
    ModuleList             = @()

    # List of all files contained in this module
    FileList               = @()

    # Private data that needs to be passed to this module
    PrivateData            = @{
        PSData = @{
            Tags         = @('vTiger', 'CRM', 'REST', 'API', 'WebService', 'Integration')
            ProjectUri   = 'https://github.com/your-username/vtWebservice'
            LicenseUri   = 'https://github.com/your-username/vtWebservice/blob/main/LICENSE'
            IconUri      = 'https://github.com/your-username/vtWebservice/blob/main/icon.png'
            ReleaseNotes = @'
## v1.8 Release Notes
- Added integrated authentication function Connect-vtSession
- Fixed module manifest and documentation
- Enhanced error handling and logging
- Improved parameter validation
- Added comprehensive help documentation
'@
        }
    }

}