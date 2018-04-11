<#
    Deployed with PSDeploy
        - https://github.com/RamblingCookieMonster/PSDeploy
#>
$PSScriptRootParent = Split-Path $PSScriptRoot -Parent

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