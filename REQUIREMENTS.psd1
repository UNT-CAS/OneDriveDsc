<#
    REQUIREMENTS installed with [PSDepend](https://github.com/RamblingCookieMonster/PSDepend):

    See `.appveyor.yml::install` for details on preparing the system to use PSDepend.
#>
@{
    'Pester'            = 'latest'  # Tested with: 4.3.1
    'powershell-yaml'   = 'latest'  # Tested with: 0.3.2
    'psake'             = 'latest'  # Tested with: 4.7.0
    'PSDeploy'          = 'latest'  # Tested with: 0.2.3
    'PSScriptAnalyzer'  = 'latest'  # Tested with: 1.11.0
    'Codecov.zip'       = @{
        DependencyType = 'FileDownload'
        Source = 'https://github.com/codecov/codecov-exe/releases/download/1.0.3/Codecov.zip'
        Target = '$PWD\Codecov.zip'
    }
    'Codecov.exe'       = @{
        DependencyType = 'task'
        Target = '$PWD\requirements.codecov.exe.ps1'
        DependsOn = 'Codecov.zip'
    }
}