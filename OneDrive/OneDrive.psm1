<#
.Synopsis
Various group policy settings for the OneDrive sync client, especially for configuring settings specific to enterprise functionality in the client.
.Description
Various group policy settings for the OneDrive sync client, especially for configuring settings specific to enterprise functionality in the client.

Can apply both computer and user policies with this resource.
.Parameter AllowTenantList
This setting lets you prevent users from easily uploading files to other organizations by specifying a list of allowed tenant IDs.

Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/cOneDrive#allowtenantlist
.Parameter BlockTenantList
This setting lets you prevent users from easily uploading files to another organization by specifying a list of blocked tenant IDs.

Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/cOneDrive#blocktenantlist
.Parameter FilesOnDemandEnabled
This setting allows you to explicitly control whether OneDrive Files On-Demand is enabled for your tenant.

Supported on: At least Windows Server, Windows 10 Version 1709. More Info: https://github.com/UNT-CAS/cOneDrive#filesondemandenabled
.Parameter DehydrateSyncedTeamSites
This policy applies if OneDrive Files On-Demand is enabled.

Supported on: At least Windows Server, Windows 10 Version 1709. More Info: https://github.com/UNT-CAS/cOneDrive#dehydratesyncedteamsites
.Parameter PreventNetworkTrafficPreUserSignIn
Enable this setting to prevent the OneDrive sync client (OneDrive.exe) from generating network traffic (checking for updates, etc.) until the user signs in to OneDrive or starts syncing files to the local computer.

Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/cOneDrive#preventnetworktrafficpreusersignin
.Parameter RemoteAccess32
This setting allows you to block users from using the fetch feature when they are logged in to OneDrive.exe with their Microsoft account.
The fetch feature allows your users to go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive Sync Client, and access all their personal files from that computer.
By default, users can use the fetch feature.

Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/cOneDrive#remoteaccess32
.Parameter RemoteAccess64
This setting allows you to block users from using the fetch feature when they are logged in to OneDrive.exe with their Microsoft account.
The fetch feature allows your users to go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive Sync Client, and access all their personal files from that computer.
By default, users can use the fetch feature.

Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/cOneDrive#remoteaccess64
.Parameter AutomaticUploadBandwidthPercentage
This setting allows you to configure the maximum percentage of the available bandwidth on the computer that OneDrive sync will use to upload.
(OneDrive only uses this bandwidth when syncing files.)
The bandwidth available to a computer is constantly changing so a percentage allows sync to respond to both increases and decreases in bandwidth availability while syncing in the background.
The lower the percentage of bandwidth OneDrive sync is allowed to take, the slower the computer will sync files.
Microsoft recommends a value of 50% or higher.
Sync enables upload limiting by periodically allowing the sync engine to go full speed for one minute and then slowing down to the upload percentage set by this setting.
This enables two key scenarios.
First, a very small file will get uploaded quickly because it can fit in the interval where sync is measuring the maximum possible speed.
Second, for any long running upload, sync will keep optimizing the upload speed per the percentage value set by this setting.

Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/cOneDrive#automaticuploadbandwidthpercentage
.Parameter SilentAccountConfig
This setting allows you to configure OneDrive silently using the primary Windows account.

Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/cOneDrive#silentaccountconfig
.Parameter DiskSpaceCheckThresholdMB
This setting is used in conjunction with SilentAccountConfig.
Any user who has a OneDrive for Business that is larger than the specified threshold (in MB) will be prompted to choose the folders they would like to sync before OneDrive downloads the files. 

Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/cOneDrive#diskspacecheckthresholdmb
.Example
# Set AllowTenantList to Absent
OneDrive -AllowTenantList @()
.Notes
https://getadmx.com/?Category=OneDrive
#>
Configuration OneDrive {
    Param (
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Allow syncing OneDrive accounts for only specific organizations'
        )]
        [string[]] $AllowTenantList = @()
        ,
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Block syncing OneDrive accounts for specific organizations'
        )]
        [string[]] $BlockTenantList = @()
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Enable OneDrive Files On-Demand'
        )]
        [string] $FilesOnDemandEnabled
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Migrate Pre-existing TeamSites with OneDrive Files On-Demand'
        )]
        [string] $DehydrateSyncedTeamSites
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Prevent OneDrive from generating network traffic until the user signs in to OneDrive'
        )]
        [string] $PreventNetworkTrafficPreUserSignIn
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Prevent users from using the remote file fetch feature to access files on the computer (32-bit)'
        )]
        [string] $RemoteAccess32
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Prevent users from using the remote file fetch feature to access files on the computer (64-bit)'
        )]
        [string] $RemoteAccess64
        ,
        [ValidateRange(0,99)] 
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Set the maximum percentage of upload bandwidth that OneDrive.exe uses'
        )]
        [int] $AutomaticUploadBandwidthPercentage
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'Silently configure OneDrive using the primary Windows account'
        )]
        [string] $SilentAccountConfig
        ,
        [Parameter(
            Mandatory=$False,
            HelpMessage = 'The maximum size of a user's OneDrive for Business before they will be prompted to choose which folders are downloaded'
        )]
        [hashtable] $DiskSpaceCheckThresholdMB = @{}
    )


    if ($PSBoundParameters.Keys -contains 'AllowTenantList') {
        if ($AllowTenantList) {
            $i = 0
            foreach ($Tenant in $Policy_OneDrive_AllowTenantList) {
                $i++
                Registry "Policy_OneDrive_AllowTenantList_${i}" {
                    Ensure    = 'Present'
                    Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\AllowTenantList'
                    ValueName = $i
                    ValueType = 'String'
                    ValueData = $Tenant
                }
            }


            # Cleanup excess allowed tenants ...
            $AllowedTenantList_reg = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive\AllowTenantList'
            $DependsOn = (1..$i) | %{ @() + @("[Registry]Policy_OneDrive_AllowTenantList_${_}") }
            Script 'Policy_OneDrive_AllowTenantList' {
                GetScript = {
                    $AllowedTenantList = Get-ItemProperty $using:AllowedTenantList_reg
                    $AllowedTenantHashtable = @{}
                    foreach ($AllowedTenant in ($AllowedTenantList.PSObject.Properties | Where-Object{ $_.Name -as [int] })) {
                        $AllowedTenantHashtable.Add($AllowedTenant.Name, $AllowedTenant.Value)
                    }
                    return @{ 'Result' = ($AllowedTenantHashtable | Out-String).Trim() }
                }
                SetScript = {
                    $AllowedTenantList = Get-ItemProperty $using:AllowedTenantList_reg
                    $AllowedTenantHashtable = @{}
                    foreach ($AllowedTenant in ($AllowedTenantList.PSObject.Properties | Where-Object{ $_.Name -as [int] -and $_.Name -gt $using:i } )) {
                        Remove-ItemProperty -Path $using:AllowedTenantList_reg -Name $AllowedTenant.Name -Force
                    }
                }
                TestScript = {
                    $AllowedTenantList = Get-ItemProperty $using:AllowedTenantList_reg
                    if (($AllowedTenantList.PSObject.Properties | Where-Object{ $_.Name -as [int] } | Measure-Object).Count -eq $using:i) {
                        return $true
                    } else {
                        return $false
                    }
                }
                DependsOn = $DependsOn
            }
        } else {
            Registry "Policy_OneDrive_AllowTenantList_${i}" {
                Ensure    = 'Absent'
                Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\AllowTenantList'
            }
        }
    }


    if ($PSBoundParameters.Keys -contains 'BlockTenantList') {
        if ($BlockTenantList) {
            $i = 0
            foreach ($Tenant in $Policy_OneDrive_BlockTenantList) {
                $i++
                Registry "Policy_OneDrive_BlockTenantList_${i}" {
                    Ensure    = 'Present'
                    Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\BlockTenantList'
                    ValueName = $i
                    ValueType = 'String'
                    ValueData = $Tenant
                }
            }

            # Cleanup excess blocked tenants ...
            $BlockedTenantList_reg = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive\BlockTenantList'
            $DependsOn = (1..$i) | %{ @() + @("[Registry]Policy_OneDrive_BlockTenantList_${_}") }
            Script 'Policy_OneDrive_BlockTenantList' {
                GetScript = {
                    $BlockedTenantList = Get-ItemProperty $using:BlockedTenantList_reg
                    $BlockedTenantHashtable = @{}
                    foreach ($BlockedTenant in ($BlockedTenantList.PSObject.Properties | Where-Object{ $_.Name -as [int] })) {
                        $BlockedTenantHashtable.Add($BlockedTenant.Name, $BlockedTenant.Value)
                    }
                    return @{ 'Result' = ($BlockedTenantHashtable | Out-String).Trim() }
                }
                SetScript = {
                    $BlockedTenantList = Get-ItemProperty $using:BlockedTenantList_reg
                    $BlockedTenantHashtable = @{}
                    foreach ($BlockedTenant in ($BlockedTenantList.PSObject.Properties | Where-Object{ $_.Name -as [int] -and $_.Name -gt $using:i } )) {
                        Remove-ItemProperty -Path $using:BlockedTenantList_reg -Name $BlockedTenant.Name -Force
                    }
                }
                TestScript = {
                    $BlockedTenantList = Get-ItemProperty $using:BlockedTenantList_reg
                    if (($BlockedTenantList.PSObject.Properties | Where-Object{ $_.Name -as [int] } | Measure-Object).Count -eq $using:i) {
                        return $true
                    } else {
                        return $false
                    }
                }
                DependsOn = $DependsOn
            }
        } else {
            Registry "Policy_OneDrive_BlockTenantList_${i}" {
                Ensure    = 'Absent'
                Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\BlockTenantList'
            }
        }
    }


    if ($FilesOnDemandEnabled) {
        Registry Policy_OneDrive_FilesOnDemandEnabled {
            Ensure    = $FilesOnDemandEnabled
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
            ValueName = 'FilesOnDemandEnabled'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($DehydrateSyncedTeamSites) {
        Registry Policy_OneDrive_DehydrateSyncedTeamSites {
            Ensure    = $DehydrateSyncedTeamSites
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
            ValueName = 'DehydrateSyncedTeamSites'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($PreventNetworkTrafficPreUserSignIn) {
        Registry Policy_OneDrive_PreventNetworkTrafficPreUserSignIn {
            Ensure    = $PreventNetworkTrafficPreUserSignIn
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
            ValueName = 'PreventNetworkTrafficPreUserSignIn'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($RemoteAccess32) {
        Registry Policy_OneDrive_RemoteAccess32 {
            Ensure    = $RemoteAccess32
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\OneDrive\Remote Access'
            ValueName = 'GPOEnabled'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($RemoteAccess64) {
        Registry Policy_OneDrive_RemoteAccess64 {
            Ensure    = $RemoteAccess64
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\OneDrive'
            ValueName = 'GPOEnabled'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($PSBoundParameters.Keys -contains 'AutomaticUploadBandwidthPercentage') {
        if ($AutomaticUploadBandwidthPercentage) {
            if (
                [int]$AutomaticUploadBandwidthPercentage -lt 10 -or
                [int]$AutomaticUploadBandwidthPercentage -gt 99
            ) {
                Throw [System.Management.Automation.ParameterBindingException] "[OneDrive] Policy_OneDrive_AutomaticUploadBandwidthPercentage Value Out of Range (0 or 10 to 99 inclusive): $($Threshold.Name): $($Threshold.Value)"
            }
            Registry Policy_OneDrive_AutomaticUploadBandwidthPercentage {
                Ensure    = 'Present'
                Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
                ValueName = 'AutomaticUploadBandwidthPercentage'
                ValueType = 'Dword'
                ValueData = $AutomaticUploadBandwidthPercentage
            }
        } else {
            Registry Policy_OneDrive_AutomaticUploadBandwidthPercentage {
                Ensure    = 'Absent'
                Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
                ValueName = 'AutomaticUploadBandwidthPercentage'
            }
        }
    }


    if ($SilentAccountConfig) {
        Registry Policy_OneDrive_SilentAccountConfig {
            Ensure    = $SilentAccountConfig
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
            ValueName = 'SilentAccountConfig'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($PSBoundParameters.Keys -contains 'DiskSpaceCheckThresholdMB') {
        if ($DiskSpaceCheckThresholdMB) {
            $i = 0
            foreach ($Threshold in $DiskSpaceCheckThresholdMB) {
                if ($Threshold.Name -as [guid]) {
                    Throw [System.Management.Automation.ParameterBindingException] "[OneDrive] Policy_OneDrive_DiskSpaceCheckThresholdMB Name should be a GUID: $($Threshold.Name)"
                }
                if (-not ($Threshold.Value -as [int])) {
                    Throw [System.Management.Automation.ParameterBindingException] "[OneDrive] Policy_OneDrive_DiskSpaceCheckThresholdMB Value must be of type [int]: $($Threshold.Name): [$($Threshold.Value.GetType().FullName)] $($Threshold.Value)"
                }
                if (
                    [int]$Threshold.Value -lt 0 -or
                    [int]$Threshold.Value -gt 4294967295
                ) {
                    Throw [System.Management.Automation.ParameterBindingException] "[OneDrive] Policy_OneDrive_DiskSpaceCheckThresholdMB Value Out of Range (0 to 4294967295 inclusive): $($Threshold.Name): $($Threshold.Value)"
                }
                if (($Threshold.Value -as [int]) -ne $Threshold.Value) {
                    Write-Warning "[OneDrive] Policy_OneDrive_DiskSpaceCheckThresholdMB Changed Value of '$($Threshold.Name)' from '[$($Threshold.Value.GetType().FullName)] $($Threshold.Value)' to '[$(($Threshold.Value -as [int]).GetType().FullName)] $(($Threshold.Value -as [int]))'"
                }

                $i++
                Registry "Policy_OneDrive_DiskSpaceCheckThresholdMB_${i}" {
                    Ensure    = 'Present'
                    Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\DiskSpaceCheckThresholdMB'
                    ValueName = $Threshold.Name
                    ValueType = 'String'
                    ValueData = [int]$Threshold.Value
                }
            }

            # Cleanup excess thresholds ...
            $DiskSpaceCheckThresholdMB_reg = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive\DiskSpaceCheckThresholdMB'
            $DependsOn = (1..$i) | %{ @() + @("[Registry]Policy_OneDrive_DiskSpaceCheckThresholdMB_${_}") }
            $DiskSpaceCheckThresholdMB_Keys = $DiskSpaceCheckThresholdMB.Keys
            Script 'Policy_OneDrive_DiskSpaceCheckThresholdMB' {
                GetScript = {
                    $DiskSpaceCheckThresholdMB = Get-ItemProperty $using:DiskSpaceCheckThresholdMB_reg
                    $ThresholdHashtable = @{}
                    foreach ($Threshold in ($DiskSpaceCheckThresholdMB.PSObject.Properties | Where-Object{ $_.Name -as [guid] })) {
                        $ThresholdHashtable.Add($Threshold.Name, $Threshold.Value)
                    }
                    return @{ 'Result' = ($ThresholdHashtable | Out-String).Trim() }
                }
                SetScript = {
                    $DiskSpaceCheckThresholdMB = Get-ItemProperty $using:DiskSpaceCheckThresholdMB_reg
                    $ThresholdHashtable = @{}
                    foreach ($Threshold in ($DiskSpaceCheckThresholdMB.PSObject.Properties | Where-Object{ $_.Name -as [guid] -and $using:DiskSpaceCheckThresholdMB_Keys -notcontains $_.Name })) {
                        Remove-ItemProperty -Path $using:DiskSpaceCheckThresholdMB_reg -Name $Threshold.Name -Force
                    }
                }
                TestScript = {
                    $DiskSpaceCheckThresholdMB = Get-ItemProperty $using:DiskSpaceCheckThresholdMB_reg
                    if (($DiskSpaceCheckThresholdMB.PSObject.Properties | Where-Object{ $_.Name -as [guid]-and $using:DiskSpaceCheckThresholdMB_Keys -notcontains $_.Name } | Measure-Object).Count -eq 0) {
                        return $true
                    } else {
                        return $false
                    }
                }
                DependsOn = $DependsOn
            }
        } else {
            Registry Policy_OneDrive_DiskSpaceCheckThresholdMB {
                Ensure    = 'Absent'
                Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\DiskSpaceCheckThresholdMB'
            }
        }
    }
}
