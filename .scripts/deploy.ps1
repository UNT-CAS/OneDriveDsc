<#
    Deployed with PSDeploy
        - https://github.com/RamblingCookieMonster/PSDeploy
#>
Deploy Module {
    By PSGalleryModule $env:APPVEYOR_PROJECT_NAME {
        FromSource "${PSScriptRoot}\BuildOutput\${env:APPVEYOR_PROJECT_NAME}"
        To PSGallery
        # Tagged Testing
        WithOptions @{
            ApiKey = $env:PSGalleryApiKey
        }
    }
}