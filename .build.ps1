<#
    .SYNOPSIS
        Prepare this machine; *installing* this module in a location accessible by DSC.

    .DESCRIPTION
        Uses [psake](https://github.com/psake/psake) to prepare this machine; *installing* this module in a location accessible by DSC.

        May do different tasks depending on the environment it's running in. Read the code for the details on that.
    .EXAMPLE
        # Run this Build Script:
        
        Invoke-psake .\.Build.ps1
    .EXAMPLE
        # Run this Build Script with different parameters/properties 'thisModuleName':

        Invoke-psake .\.Build.ps1 -Parameters @{"thisModuleName"='OtherModuleName'}
    .EXAMPLE
        # Run this Build Script with a parameters/properties that's not otherwise defined:
        
        Invoke-psake .\.Build.ps1 -Parameters @{"Version"=[version]'1.2.3'}
#>
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 'latest'

$script:thisModuleName = $null
$script:ManifestJsonFile = $null
$script:BuildOutput = $null

$script:Manifest = @{}
$script:Manifest.Add('ModuleName',  $null)
$script:Manifest.Add('ResourceName',  $null)
$script:Manifest.Add('Copyright',  $null)

$script:Manifest_ModuleName = $null
$script:Manifest_ResourceName = $null
$script:ParentModulePath = $null
$script:ResourceModulePath = $null
$script:SystemModuleLocation = $null
$script:DependsBootstrap = if ($Properties.Keys -contains 'SkipBootStrap' -and $Properties.SkipBootStrap) { $null } else { 'Bootstrap' }
$script:VersionBuild = $null

# Parameters:
Properties {
    $script:thisModuleName = 'OneDrive'
    $script:ManifestJsonFile = "${PSScriptRoot}\${script:thisModuleName}\Manifest.json"
    $script:BuildOutput = "${PSScriptRoot}\BuildOutput"

    # Manipulate the Parameters for usage:
    $Manifest_obj = Get-Content $script:ManifestJsonFile | ConvertFrom-Json
    $Manifest_obj | Get-Member -MemberType Properties | ForEach-Object { $script:Manifest.Set_Item($_.Name, $Manifest_obj.($_.Name)) }
    $script:Manifest.Copyright = $script:Manifest.Copyright -f [DateTime]::Now.Year

    $script:Manifest_ModuleName = $script:Manifest.ModuleName
    $script:Manifest_ResourceName = $script:Manifest.ResourceName
    $script:Manifest.Remove('ModuleName')
    $script:Manifest.Remove('ResourceName')

    $script:ParentModulePath = "${script:BuildOutput}\${script:Manifest_ModuleName}"
    $script:ResourceModulePath = "${script:ParentModulePath}\DSCResources\${script:Manifest_ResourceName}"

    $PSModulePath1 = $env:PSModulePath.Split(';')[1]
    $script:SystemModuleLocation = "${PSModulePath1}\${script:Manifest_ModuleName}"

    $script:VersionBuild = if ($env:APPVEYOR_BUILD_NUMBER) { $env:APPVEYOR_BUILD_NUMBER } else { 0 }
}

# Start psake builds
Task default -Depends InstallModule



<#
    Bootstrap PSDepend:
        - https://github.com/RamblingCookieMonster/PSDepend
    Install Dependencies
#>
Task Bootstrap -Description "Bootstrap & Run PSDepend" {
    if (Get-Module -Name 'PSDepend')
    {
        Update-Module -Name 'PSDepend' -Force
    }
    else
    {
        Install-Module -Name 'PSDepend' -Force
    }

    Import-Module -Name 'PSDepend'
    Invoke-PSDepend -Path "${PSScriptRoot}\REQUIREMENTS.psd1" -Force
}



<#
    Preperation and Setup:
        - Import Manifest.json to create the PDS1 file.
        - Modify Manifest information; keeping purged information.
        - Establish Module/Resource Locations/Paths.
#>
Task SetupModule -Description "Prepare and Setup Module" -Depends $DependsBootstrap {
    New-Item -ItemType 'Directory' -Path $script:ResourceModulePath -Force | Out-Null

    $script:Manifest.Path = "${script:ParentModulePath}\${script:Manifest_ModuleName}.psd1"
    $script:Manifest.DscResourcesToExport = $script:Manifest_ResourceName
    $script:Manifest.ModuleVersion = "$($script:Manifest.ModuleVersion).${script:VersionBuild}"
    New-ModuleManifest @script:Manifest

    $script:Manifest.Path = "${script:ResourceModulePath}\${script:Manifest_ResourceName}.psd1"
    $script:Manifest.RootModule = "${script:Manifest_ResourceName}.schema.psm1"
    New-ModuleManifest @script:Manifest

    Copy-Item -LiteralPath "${PSScriptRoot}\${script:thisModuleName}\${script:thisModuleName}.schema.psm1" -Destination $script:ResourceModulePath -Force
}



<#
    Put Module/Resource in locations accessible by DSC:
        - Create the PSD1 files from Manifest.
        - Copy PSM1 to location.
        - Copy Module to System Location; for testing.
#>
Task InstallModule -Description "Prepare and Setup/Install Module" -Depends SetupModule {
    New-Item -ItemType 'Directory' -Path $script:SystemModuleLocation -Force | Out-Null

    Copy-Item -Path "${script:BuildOutput}\*" -Destination $script:SystemModuleLocation -Recurse -Force
}
