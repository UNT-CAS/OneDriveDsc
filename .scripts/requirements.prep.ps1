<#
    .Synopsis
        Extract Codecov.exe from the ZIP file.
    .Description
        PSDepend can't run complex tasks, and currently can't extract a FileDownload that's a ZIP file.
#>
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 'latest'



# Enable TLS v1.2 (for GitHub et al.)
Write-Verbose "[REQUIREMENTS Prep] SecurityProtocol OLD: $([System.Net.ServicePointManager]::SecurityProtocol)"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
Write-Verbose "[REQUIREMENTS Prep] SecurityProtocol NEW: $([System.Net.ServicePointManager]::SecurityProtocol)"



# Create Temp Directory
$New_Item = @{
    ItemType = 'Directory'
    Path     = "${PSScriptRoot}\.temp"
    Force    = $true
}
Write-Verbose "[REQUIREMENTS Prep] New-Item: $($New_Item | ConvertTo-Json -Compress)"
New-Item @New_Item