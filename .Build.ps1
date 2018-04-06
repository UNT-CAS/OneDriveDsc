param(
    [string] $thisModuleName = 'OneDrive'
)



<#
    Preperation and Setup:
        - Import Manifest.json to create the PDS1 file.
        - Modify Manifest information; keeping purged information.
        - Establish Module/Resource Locations/Paths.
#>
$Manifest = @{}
$Manifest_obj = Get-Content "${PSScriptRoot}\${thisModuleName}\Manifest.json" | ConvertFrom-Json
$Manifest_obj | Get-Member -MemberType Properties | ForEach-Object { $Manifest.Add($_.Name,$Manifest_obj.($_.Name)) }
$Manifest.Copyright = $Manifest.Copyright -f [DateTime]::Now.Year

$Manifest_ModuleName = $Manifest.ModuleName
$Manifest_ResourceName = $Manifest.ResourceName
$Manifest.Remove('ModuleName')
$Manifest.Remove('ResourceName')

$PSModulePath1 = $env:PSModulePath.Split(';')[1]
$ParentModulePath = "${PSModulePath1}\${Manifest_ModuleName}"
$ResourceModulePath = "${ParentModulePath}\DSCResources\${Manifest_ResourceName}"

New-Item -ItemType 'Directory' -Path $ResourceModulePath -Force | Out-Null



<#
    Put Module/Resource in locations accessible by DSC:
        - Create the PSD1 files from Manifest.
        - Copy PSM1 to location.
#>
$Manifest.Path = "${ParentModulePath}\${Manifest_ModuleName}.psd1"
New-ModuleManifest @Manifest

$Manifest.Path = "${ResourceModulePath}\${Manifest_ResourceName}.psd1"
$Manifest.RootModule = "${Manifest_ResourceName}.schema.psm1"
New-ModuleManifest @Manifest

Copy-Item -LiteralPath "${PSScriptRoot}\${thisModuleName}\${thisModuleName}.schema.psm1" -Destination $ResourceModulePath -Force



<#
    If this script was called from within something else, like Pester:
        - Restore purged Manifest information.
        - Return the Manifest Object.
#>
if ($MyInvocation.CommandOrigin -ne 'Runspace') {
    $Manifest.ModuleName = $Manifest_ModuleName
    $Manifest.ResourceName = $Manifest_ResourceName
    return $Manifest
}