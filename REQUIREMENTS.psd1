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
    'CodeCovIo.psm1' = @{
        DependencyType = 'FileDownload'
        Source = 'https://raw.githubusercontent.com/PowerShell/DscResource.Tests/491688867dc53894b92ca53520a18d145deb7760/DscResource.CodeCoverage/CodeCovIo.psm1'
        Target = '$PWD/CodeCovIo.psm1'
    }
    'Codecov.zip'       = @{
        DependencyType = 'FileDownload'
        Source = 'https://github.com/codecov/codecov-exe/releases/download/1.0.3/Codecov.zip'
        Target = '$PWD\Codecov.zip'
    }
    'Codecov'       = @{
        DependencyType = 'task'
        Target = '$PWD\.scripts\requirements.codecov.ps1'
        DependsOn = @('Codecov.zip', 'CodeCovIo.psm1')
    }
}