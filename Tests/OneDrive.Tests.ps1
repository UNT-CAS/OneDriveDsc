[CmdletBinding()]
param(
    [string] $thisModuleName = 'OneDrive'
    ,
    [string] $DSCModulePath  = "${SystemRoot}\System32\WindowsPowerShell\v1.0\Modules"
    ,
    [bool]   $CleanUp        = $true
)

$ParentModulePath = "${env:ProgramFiles}\WindowsPowerShell\Modules\${thisModuleName}"
$ResourceModulePath = "${ParentModulePath}\DSCResources\${thisModuleName}"
$PSScriptRootParent = $(Split-Path $PSScriptRoot -Parent)


$Manifest = & "${PSScriptRootParent}\.Build.ps1"
Remove-Module $thisModuleName -ErrorAction 'SilentlyContinue'

function Invoke-PesterTestCleaup {
    Invoke-DscCleanup

    Remove-Item -LiteralPath "${DSCModulePath}\${thisModuleName}" -Force
    $env:PSModulePath = $script:PSModulePathORIG
}

function Invoke-DscCleanup {
    #Remove all mof files (pending,current,backup,MetaConfig.mof,caches,etc)
    Remove-Item 'C:\windows\system32\Configuration\*.mof*' -Force -ErrorAction 'Ignore'
    #Kill the LCM/DSC processes
    Get-Process 'wmi*' | Where-Object { $_.modules.ModuleName -like "*DSC*" } | Stop-Process -Force
}

Describe $thisModuleName {
    # AfterEach { Start-Sleep -Seconds 5 }



    Context 'Script Analyzer' {
        if (-not (Get-Command 'Invoke-ScriptAnalyzer' -ErrorAction 'SilentlyContinue')) {
            Install-Module -Name PSScriptAnalyzer -RequiredVersion 1.11.0 -Force
        }

        $ScriptAnalyzerRules = Get-ScriptAnalyzerRule | Where-Object {$_.SourceName -eq 'PSDSC'}

        foreach ($Rule in $ScriptAnalyzerRules) {
            It "Should not return any violation for the rule : $($Rule.RuleName)" {
                Invoke-ScriptAnalyzer -Path "${PSScriptRootParent}\${thisModuleName}\${thisModuleName}.schema.psm1" -IncludeRule $Rule.RuleName | Should BeNullOrEmpty
            }
        }
    }



    Context 'Class Available' {
        It 'Module Available' {
            Get-Module -Name $Manifest.ModuleName -Refresh -ListAvailable -ErrorAction 'SilentlyContinue' | Should Not BeNullOrEmpty
        }

        It 'Module Count' {
            (Get-Module -Name $Manifest.ModuleName -Refresh -ListAvailable -ErrorAction 'SilentlyContinue').Count | Should Be 1
        }

        It 'DscResource' {
            Get-DscResource $Manifest.ResourceName -ErrorAction 'SilentlyContinue' | Should Not BeNullOrEmpty
        }

        It 'DscResource Name' {
            (Get-DscResource $Manifest.ResourceName -ErrorAction 'SilentlyContinue').Name | Should Be $Manifest.ResourceName
        }

        It 'DscResource ResourceType' {
            (Get-DscResource $Manifest.ResourceName -ErrorAction 'SilentlyContinue').ResourceType | Should Be $Manifest.ResourceName
        }

        It 'DscResource Version' {
            (Get-DscResource $Manifest.ResourceName -ErrorAction 'SilentlyContinue').Version | Should Be $Manifest.ModuleVersion
        }
    }



    foreach ($example in (Get-ChildItem "${PSScriptRootParent}\Examples").FullName) {
        Invoke-DscCleanup
        Context "Configuration: ${example}" {
            . $example

            It 'Build Configuration' {
                { Demo_Configuration } | Should Not Throw
            }

            It 'Build Configuration Type' {
                Demo_Configuration | Should BeOfType 'System.IO.FileInfo'
            }

            while (-not ($tested = Test-DscConfiguration "${PSScriptRootParent}\Demo_Configuration" -ErrorAction 'Ignore')) {
                Write-Host "`tWaiting for DSC to become available ..." -ForegroundColor 'Gray'
                Start-Sleep -Seconds 1
            }
            It 'Test Configuration' {
                { Test-DscConfiguration "${PSScriptRootParent}\Demo_Configuration" -ErrorAction 'Stop' } | Should Not Throw
            }

            It 'Test Configuration Type' {
                Write-Verbose 'If this test fails, it is likely not our fault. Assuming the prev test passed.'
                $tested | Should BeOfType 'System.Management.Automation.PSCustomObject'
            }

            It 'Test Configuration In Desired State: False' {
                # We haven't applied the Configuration yet, so this should be false.
                $tested.InDesiredState | Should Be $FALSE
            }

            It 'Apply Configuration' {
                { Start-DscConfiguration '.\Demo_Configuration' -Wait -Force -ErrorAction 'Stop' } | Should Not Throw
            }

            while (-not ($tested = Test-DscConfiguration "${PSScriptRootParent}\Demo_Configuration" -ErrorAction 'Ignore')) {
                Write-Host "`tWaiting for DSC to become available ..." -ForegroundColor 'Gray'
                Start-Sleep -Seconds 1
            }
            It 'Test Configuration' {
                { Test-DscConfiguration "${PSScriptRootParent}\Demo_Configuration" -ErrorAction 'Stop' } | Should Not Throw
            }

            It 'Test Configuration In Desired State: True' {
                # We have applied the Configuration, so this should be true.
                $tested.InDesiredState | Should Be $TRUE
            }
        }

        Remove-DscConfigurationDocument -Stage Current
    }
}

if ($CleanUp.IsPresent) {
    Invoke-PesterTestCleaup
}