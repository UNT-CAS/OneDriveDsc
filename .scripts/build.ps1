<#
    .Synopsis
        Prepare this machine; *installing* this module in a location accessible by DSC.

    .Description
        Uses [psake](https://github.com/psake/psake) to prepare this machine; *installing* this module in a location accessible by DSC.

        May do different tasks depending on the environment it's running in. Read the code for the details on that.
    .Example
        # Run this Build Script:
        
        Invoke-psake .\.build.ps1
    .Example
        # Skip Bootstrap

        Invoke-psake .\.build.ps1 -Parameters @{'SkipBootStrap'=$true}
    .Example
        # Run this Build Script with different parameters/properties 'thisModuleName':

        Invoke-psake .\.build.ps1 -Parameters @{'thisModuleName'='OtherModuleName'}
    .Example
        # Run this Build Script with a parameters/properties that's not otherwise defined:
        
        Invoke-psake .\.build.ps1 -Parameters @{'Version'=[version]'1.2.3'}
#>
$ErrorActionPreference = 'Stop'

$script:thisModuleName = 'OneDrive'
$script:PSScriptRootParent = Split-Path $PSScriptRoot -Parent
$script:ManifestJsonFile = "${PSScriptRootParent}\${thisModuleName}\Manifest.json"
$script:BuildOutput = "${PSScriptRootParent}\BuildOutput"

$script:Manifest = @{}
$Manifest_obj = Get-Content $script:ManifestJsonFile | ConvertFrom-Json
$Manifest_obj | Get-Member -MemberType Properties | ForEach-Object { $script:Manifest.Set_Item($_.Name, $Manifest_obj.($_.Name)) }

$script:Manifest_ModuleName = $null
$script:Manifest_ResourceName = $null
$script:ParentModulePath = $null
$script:ResourceModulePath = $null
$script:SystemModuleLocation = $null
$script:DependsBootstrap = if ($Properties.Keys -contains 'SkipBootStrap' -and $Properties.SkipBootStrap) { $null } else { 'Bootstrap' }
$script:VersionBuild = $null

if (-not $env:CI) {
    Get-Module $Manifest.ModuleName -ListAvailable -Refresh | Uninstall-Module -Force -ErrorAction 'SilentlyContinue'
    (Get-Module $Manifest.ModuleName -ListAvailable -Refresh).ModuleBase | Remove-Item -Recurse -Force -ErrorAction 'SilentlyContinue'
}

# Parameters:
Properties {
    $thisModuleName = $script:thisModuleName
    $PSScriptRootParent = $script:PSScriptRootParent
    $ManifestJsonFile = $script:ManifestJsonFile
    $BuildOutput = $script:BuildOutput

    # Manipulate the Parameters for usage:
    
    $script:Manifest.Copyright = $script:Manifest.Copyright -f [DateTime]::Now.Year

    $script:Manifest_ModuleName = $script:Manifest.ModuleName
    $script:Manifest_ResourceName = $script:Manifest.ResourceName
    $script:Manifest.Remove('ModuleName')
    $script:Manifest.Remove('ResourceName')

    $script:ParentModulePath = "${script:BuildOutput}\${script:Manifest_ModuleName}"
    $script:ResourceModulePath = "${script:ParentModulePath}\DSCResources\${script:Manifest_ResourceName}"

    $PSModulePath1 = $env:PSModulePath.Split(';')[1]
    $script:SystemModuleLocation = "${PSModulePath1}\${script:Manifest_ModuleName}"

    $script:Version = [string](& "${PSScriptRootParent}\.scripts\version.ps1")
}



# Start psake builds
Task default -Depends InstallModule



<#
    Bootstrap PSDepend:
        - https://github.com/RamblingCookieMonster/PSDepend
    Install Dependencies
#>
Task Bootstrap -Description "Bootstrap & Run PSDepend" {
    $PSDepend = Get-Module -Name 'PSDepend'
    Write-Verbose "[BUILD Bootstrap] PSDepend: $($PSDepend.Version)"
    if (Get-Module -Name 'PSDepend')
    {
        Write-Verbose "[BUILD Bootstrap] PSDepend: Updating..."
        $PSDepend | Update-Module -Force
    }
    else
    {
        Write-Verbose "[BUILD Bootstrap] PSDepend: Installing..."
        Install-Module -Name 'PSDepend' -Force
    }

    Write-Verbose "[BUILD Bootstrap] PSDepend: Installing..."
    $PSDepend = Import-Module -Name 'PSDepend' -PassThru
    Write-Verbose "[BUILD Bootstrap] PSDepend: $($PSDepend.Version)"

    Write-Verbose "[BUILD Bootstrap] PSDepend: Invoking '${PSScriptRootParent}\REQUIREMENTS.psd1'"
    Invoke-PSDepend -Path "${PSScriptRootParent}\REQUIREMENTS.psd1" -Force
}



<#
    Preperation and Setup:
        - Import Manifest.json to create the PDS1 file.
        - Modify Manifest information; keeping purged information.
        - Establish Module/Resource Locations/Paths.
#>
Task SetupModule -Description "Prepare and Setup Module" -Depends $DependsBootstrap {
    $dir = New-Item -ItemType 'Directory' -Path $script:ResourceModulePath -Force
    Write-Verbose "[BUILD SetupModule] New Directory: ${dir}"

    $script:Manifest.Path = "${script:ParentModulePath}\${script:Manifest_ModuleName}.psd1"
    $script:Manifest.DscResourcesToExport = $script:Manifest_ResourceName
    $script:Manifest.ModuleVersion = $script:Version
    Write-Verbose "[BUILD SetupModule] New-ModuleManifest: $($script:Manifest | ConvertTo-Json -Compress)"
    New-ModuleManifest @script:Manifest

    $script:Manifest.Path = "${script:ResourceModulePath}\${script:Manifest_ResourceName}.psd1"
    $script:Manifest.RootModule = "${script:Manifest_ResourceName}.schema.psm1"
    Write-Verbose "[BUILD SetupModule] New-ModuleManifest: $($script:Manifest | ConvertTo-Json -Compress)"
    New-ModuleManifest @script:Manifest

    $Copy_Item = @{
        LiteralPath = "${PSScriptRootParent}\${script:thisModuleName}\${script:thisModuleName}.schema.psm1"
        Destination = $script:ResourceModulePath
        Force       = $true
    }
    Write-Verbose "[BUILD SetupModule] Copy-Item: $($Copy_Item | ConvertTo-Json -Compress)"
    Copy-Item @Copy_Item
}



<#
    Put Module/Resource in locations accessible by DSC:
        - Create the PSD1 files from Manifest.
        - Copy PSM1 to location.
        - Copy Module to System Location; for testing.
#>
Task InstallModule -Description "Prepare and Setup/Install Module" -Depends SetupModule {
    $New_Item = @{
        ItemType = 'Directory'
        Path     = $script:SystemModuleLocation
        Force    = $true
    }
    Write-Verbose "[BUILD SetupModule] New-Item: $($New_Item | ConvertTo-Json -Compress)"
    New-Item @New_Item | Out-Null

    $Copy_Item = @{
        Path        = "${script:BuildOutput}\*"
        Destination = $script:SystemModuleLocation
        Recurse     = $true
        Force       = $true
    }
    Write-Verbose "[BUILD SetupModule] Copy-Item: $($Copy_Item | ConvertTo-Json -Compress)"
    Copy-Item @Copy_Item
}
