<#
    Deployed with PSDeploy
        - https://github.com/RamblingCookieMonster/PSDeploy
#>
$PSScriptRootParent = Split-Path $PSScriptRoot -Parent
Write-Verbose "[Deploy] PSScriptRootParent: ${PSScriptRootParent}"
Write-Verbose "[Deploy] APPVEYOR_PROJECT_NAME: ${env:APPVEYOR_PROJECT_NAME}"
Write-Verbose "[Deploy] Fooooo: ${env:PSGalleryApiKey}"

Deploy Module {
    By PSGalleryModule OneDriveDsc {
        FromSource "${PSScriptRootParent}\BuildOutput\OneDriveDsc"
        To PSGallery
        # Tagged Testing
        WithOptions @{
            ApiKey = $env:PSGalleryApiKey
        }
    }
}