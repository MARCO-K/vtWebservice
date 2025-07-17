# vtWebservice

This module will support the work with the vTiger REST API.

## Script Samples

### Basics

```powershell
$uri = 'http://localhost/webservice.php'
$username = 'webservice'
$userAccessKey = 'somekey'
```

### Create New Session (Simplified Workflow)

```powershell
# New integrated method - One step authentication
$sessionname = Connect-vtSession -Uri $uri -Username $username -UserAccessKey $userAccessKey
```

### Create New Session (Manual Workflow)

```powershell
# Traditional 3-step method
$contentType = 'application/x-www-form-urlencoded'
$token = Get-vtSessiontoken -uri $uri -contenttype $contentType -username $username
$accessKey = Get-vtHashString -InputString ($token + $userAccessKey) -Algorithm MD5
$sessionname = Get-vtLogin -uri $uri -contenttype $contentType -username $username -accessKey $accessKey
```

### Do Some Stuff

```powershell
Get-vtListtype -uri $uri -contenttype $contentType -sessionName $sessionname
Get-vtFieldlist -uri $uri -contenttype $contentType -sessionName $sessionName -module 'Services'
New-vtRecordEntry -uri $uri -contenttype $contenttype -sessionName $sessionName -module $module -record $record
```

### Complex Example

```powershell
$qry = "select id, accountname, assigned_user_id from $mod where cf_1353 = ' ' and cf_863 = 0 order by id desc;"
$result = Get-vtQueryrecord -uri $uri -contenttype $contentType -sessionName $sessionname -querystring $qry
$res = Get-vtRetrieverecord -Uri $uri -contenttype $contentType -sessionName $sessionname -RecordIds $result.id
$res
```

### WhatIf Support

All destructive operations support PowerShell's `-WhatIf` and `-Confirm` parameters:

```powershell
# Test what would happen without actually performing the operation
Remove-vtRecord -Uri $uri -SessionName $sessionname -RecordIds "11x1" -WhatIf

# Prompt for confirmation before each operation
Update-vtRecord -Uri $uri -SessionName $sessionname -RecordId "11x1" -Record $record -Confirm
```

## Key Changes

- **New Authentication**: Use `Connect-vtSession` for streamlined authentication
- **Modern Hashing**: Use `Get-vtHashString` for all hashing operations
- **Hash Algorithms**: Support for MD5, SHA-256, and SHA-512
- **PowerShell Best Practices**: WhatIf/Confirm support, parameter validation, and PSFramework logging
- **WhatIf Support**: All destructive operations support -WhatIf and -Confirm parameters
- **Enhanced Validation**: ValidateSet for ContentType and cached module validation for better performance
