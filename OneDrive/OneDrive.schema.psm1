<#
    .Synopsis
        Various group policy settings for the OneDrive sync client, especially for configuring settings specific to enterprise functionality in the client.

    .Description
        Various group policy settings for the OneDrive sync client, especially for configuring settings specific to enterprise functionality in the client.

        Can apply both computer and user policies with this resource.

    .Parameter AllowTenantList
        This setting lets you prevent users from easily uploading files to other organizations by specifying a list of allowed tenant IDs.

        Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/OneDriveDsc#allowtenantlist

    .Parameter BlockTenantList
        This setting lets you prevent users from easily uploading files to another organization by specifying a list of blocked tenant IDs.

        Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/OneDriveDsc#blocktenantlist

    .Parameter FilesOnDemandEnabled
        This setting allows you to explicitly control whether OneDrive Files On-Demand is enabled for your tenant.

        Supported on: At least Windows Server, Windows 10 Version 1709. More Info: https://github.com/UNT-CAS/OneDriveDsc#filesondemandenabled

    .Parameter DehydrateSyncedTeamSites
        This policy applies if OneDrive Files On-Demand is enabled.

        Supported on: At least Windows Server, Windows 10 Version 1709. More Info: https://github.com/UNT-CAS/OneDriveDsc#dehydratesyncedteamsites

    .Parameter PreventNetworkTrafficPreUserSignIn
        Enable this setting to prevent the OneDrive sync client (OneDrive.exe) from generating network traffic (checking for updates, etc.) until the user signs in to OneDrive or starts syncing files to the local computer.

        Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/OneDriveDsc#preventnetworktrafficpreusersignin

    .Parameter RemoteAccess32
        This setting allows you to block users from using the fetch feature when they are logged in to OneDrive.exe with their Microsoft account.
        The fetch feature allows your users to go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive Sync Client, and access all their personal files from that computer.
        By default, users can use the fetch feature.

        Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/OneDriveDsc#remoteaccess32

    .Parameter RemoteAccess64
        This setting allows you to block users from using the fetch feature when they are logged in to OneDrive.exe with their Microsoft account.
        The fetch feature allows your users to go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive Sync Client, and access all their personal files from that computer.
        By default, users can use the fetch feature.

        Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/OneDriveDsc#remoteaccess64

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

        Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/OneDriveDsc#automaticuploadbandwidthpercentage

    .Parameter SilentAccountConfig
        This setting allows you to configure OneDrive silently using the primary Windows account.

        Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/OneDriveDsc#silentaccountconfig

    .Parameter DiskSpaceCheckThresholdMB
        This setting is used in conjunction with SilentAccountConfig.
        Any user who has a OneDrive for Business that is larger than the specified threshold (in MB) will be prompted to choose the folders they would like to sync before OneDrive downloads the files. 

        Supported on: At least Windows 7. More Info: https://github.com/UNT-CAS/OneDriveDsc#diskspacecheckthresholdmb

    .Example
        # Set AllowTenantList to Absent
        OneDrive -AllowTenantList @()

    .Notes
        https://github.com/UNT-CAS/OneDriveDsc/wiki#notes
#>
Configuration OneDrive
{
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = 'Allow syncing OneDrive accounts for only specific organizations')]
        [string[]]
        $AllowTenantList
        ,
        [Parameter(HelpMessage = 'Block syncing OneDrive accounts for specific organizations')]
        [string[]]
        $BlockTenantList
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(HelpMessage = 'Enable OneDrive Files On-Demand')]
        [string]
        $FilesOnDemandEnabled
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(HelpMessage = 'Migrate Pre-existing TeamSites with OneDrive Files On-Demand')]
        [string]
        $DehydrateSyncedTeamSites
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(HelpMessage = 'Prevent OneDrive from generating network traffic until the user signs in to OneDrive')]
        [string]
        $PreventNetworkTrafficPreUserSignIn
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(HelpMessage = 'Prevent users from using the remote file fetch feature to access files on the computer (32-bit)')]
        [string]
        $RemoteAccess32
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(HelpMessage = 'Prevent users from using the remote file fetch feature to access files on the computer (64-bit)')]
        [string]
        $RemoteAccess64
        ,
        [ValidateRange(0,99)] 
        [Parameter(HelpMessage = 'Set the maximum percentage of upload bandwidth that OneDrive.exe uses')]
        [int]
        $AutomaticUploadBandwidthPercentage
        ,
        [ValidateSet('Absent', 'Present')]
        [Parameter(HelpMessage = 'Silently configure OneDrive using the primary Windows account')]
        [string]
        $SilentAccountConfig
        ,
        [Parameter(HelpMessage = 'The maximum size of a user''s OneDrive for Business before they will be prompted to choose which folders are downloaded')]
        [hashtable]
        $DiskSpaceCheckThresholdMB
    )

    Write-Verbose ($PSBoundParameters | Out-String)



    <#
        .SYNOPSIS
            Create a DSC resource configuration based on passed parameters.
        .DESCRIPTION
            Create a DSC resource configuration based on passed parameters.
        .PARAMETER ResourceName
            
    #>
    function Get-DscSplattedResource
    {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory = $true)]
            [string]
            $ResourceName
            ,
            [Parameter(Mandatory = $true)]
            [string]
            $ExecutionName
            ,
            [Parameter()]
            [hashtable]
            $Usings
            ,
            [Parameter(Mandatory = $true)]
            [hashtable]
            $Properties
            ,
            [Parameter()]
            [switch]
            $NoInvoke
        )
        Write-Verbose "[OneDrive] Get-DscSplattedResource: $($PSBoundParameters | ConvertTo-Json -Compress)"
        
        $StringBuilder = [System.Text.StringBuilder]::new()


        $StringBuilder.AppendLine("`$Properties = @{") | Out-Null
        foreach ($Property in $Properties.GetEnumerator())
        {
            $PropertyStringBuilder = [System.Text.StringBuilder]::new()
            if ($Property.Value -is [scriptblock])
            {
                $PropertyStringBuilder.AppendLine("    $($Property.Name) = {") | Out-Null
                $PropertyStringBuilder.AppendLine($Property.Value) | Out-Null
                $PropertyStringBuilder.AppendLine('    };') | Out-Null
            }
            else
            {
                $PropertyStringBuilder.AppendLine("    $($Property.Name) = ('$($Property.Value | ConvertTo-Json -Compress)' | ConvertFrom-Json);") | Out-Null
            }
            $StringBuilder.AppendLine($PropertyStringBuilder.ToString()) | Out-Null
        }
        $StringBuilder.AppendLine("}") | Out-Null
        $StringBuilder.AppendLine() | Out-Null


        foreach ($u in $Usings.GetEnumerator())
        {
            if ($u -is [scriptblock])
            {
                $StringBuilder.AppendLine("`$$($u.Name) = {") | Out-Null
                $StringBuilder.AppendLine($u.Value) | Out-Null
                $StringBuilder.AppendLine("}") | Out-Null
            }
            else
            {
                $StringBuilder.AppendLine("`$$($u.Name) = '$($u.Value | ConvertTo-Json -Compress)' | ConvertFrom-Json") | Out-Null
            }
        }
        $StringBuilder.AppendLine() | Out-Null


        $StringBuilder.AppendLine("${ResourceName} ${ExecutionName} {") | Out-Null
        foreach ($PropertyName in $Properties.Keys)
        {
            $StringBuilder.AppendLine("    ${PropertyName} = `$Properties.$PropertyName") | Out-Null
        }
        $StringBuilder.AppendLine("}") | Out-Null
        Write-Verbose "[OneDrive] Get-DscSplattedResource StringBuilder:`n$($StringBuilder.ToString())"


        if ($NoInvoke)
        {
            Write-Verbose "[OneDrive] Get-DscSplattedResource Returning StringBuilder"
            return [scriptblock]::Create($StringBuilder.ToString())
        }
        else
        {
            Write-Verbose "[OneDrive] Get-DscSplattedResource Invoking: $($StringBuilder.ToString())"
            [scriptblock]::Create($StringBuilder.ToString()).Invoke()
        }
    }



    function Remove-OneDriveRegKey
    {
        [CmdletBinding()]
        param(
            [Parameter()]
            [string]
            $InstanceName
            ,
            [Parameter()]
            [string]
            $RegKey
        )
        Write-Verbose "[OneDrive] Remove-OneDriveRegKey: $($PSBoundParameters | ConvertTo-Json -Compress)"

        $Get_DscSplattedResource = @{
            ResourceName = 'Script'
            ExecutionName = $InstanceName
            Usings = @{
                RegKey = "Registry::${RegKey}"
            }
            Properties = @{
                GetScript = {
                    return @{ Result = "RegKeyExists: $(Test-Path $using:RegKey)" }
                }
                SetScript = {
                    Remove-Item -LiteralPath $using:RegKey -Force
                }
                TestScript = {
                    return (-not (Test-Path $using:RegKey))
                }
            }
            NoInvoke = $true
        }
        return Get-DscSplattedResource @Get_DscSplattedResource
    }



    function Remove-OneDriveExcessRegKeyValues
    {
        [CmdletBinding()]
        param(
            [Parameter()]
            [string]
            $InstanceName
            ,
            [Parameter()]
            [string]
            $RegKey
            ,
            [Parameter()]
            [array]
            $AllowedValueNames
            ,
            [Parameter()]
            [string[]]
            $DependsOn
        )
        Write-Verbose "[OneDrive] Remove-OneDriveExcessRegKeyValues: $($PSBoundParameters | ConvertTo-Json -Compress)"

        $Get_DscSplattedResource = @{
            ResourceName = 'Script'
            ExecutionName = $InstanceName
            Usings = @{
                RegKey = "Registry::${RegKey}"
                AllowedValueNames = $AllowedValueNames
            }
            Properties = @{
                GetScript = {
                    $Key = Get-Item -LiteralPath $using:RegKey
                    $ValueHashtable = @{}

                    foreach ($Value in $Key.Property)
                    {
                        $ValueHashtable.Add($Value, $Key.GetValue($Value))
                    }

                    return @{ Result = ($ValueHashtable | Out-String).Trim() }
                }
                SetScript = {
                    $Key = Get-Item -LiteralPath $using:RegKey
                    $NotAllowedValues = $Key.Property | Where-Object{ $using:AllowedValueNames -notcontains $_ }

                    foreach ($Value in $NotAllowedValues)
                    {
                        Remove-ItemProperty -LiteralPath $using:RegKey -Name $Value -Force
                    }
                }
                TestScript = {
                    $Key = Get-Item -LiteralPath $using:RegKey
                    $NotAllowedValues = $Key.Property | Where-Object{ $using:AllowedValueNames -notcontains $_ }

                    if ($NotAllowedValues.Count -gt 0)
                    {
                        return $false
                    }
                    else
                    {
                        return $true
                    }
                }
                DependsOn = $DependsOn
            }
            NoInvoke = $true
        }
        $DscSplattedResource = Get-DscSplattedResource @Get_DscSplattedResource
        return $DscSplattedResource
    }



    <#
        ######################################################################################
        # Start Processing the Parameters ...
        ######################################################################################
    #>

    if ($PSBoundParameters.Keys -contains 'AllowTenantList')
    {
        Write-Verbose "PSBoundParameters.AllowTenantList: $($PSBoundParameters.AllowTenantList)"
        if ($AllowTenantList)
        {
            Write-Verbose "AllowTenantList (True) ..."
            $i = 0
            foreach ($Tenant in $AllowTenantList)
            {
                $i++
                Write-Verbose "Creating: [Registry]Policy_OneDrive_AllowTenantList_${i}"
                Registry "Policy_OneDrive_AllowTenantList_${i}"
                {
                    Ensure    = 'Present'
                    Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\AllowTenantList'
                    ValueName = $i
                    ValueType = 'String'
                    ValueData = $Tenant
                }
            }

            # Cleanup excess allowed tenants ...
            $Remove_OneDriveExcessRegKeyValues = @{
                InstanceName = 'Policy_OneDrive_AllowTenantList'
                RegKey       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\AllowTenantList'
                AllowedValueNames = (1..$i)
                DependsOn = ((1..$i) | ForEach-Object{ @() + @("[Registry]Policy_OneDrive_AllowTenantList_${_}") })
            }
            $OneDriveExcessRegKeyValues = Remove-OneDriveExcessRegKeyValues @Remove_OneDriveExcessRegKeyValues
            $OneDriveExcessRegKeyValues.Invoke()
        }
        else
        {
            Write-Verbose "[OneDrive] AllowTenantList (False) ..."
            $Remove_OneDriveRegKey = @{
                InstanceName = 'Policy_OneDrive_AllowTenantList'
                RegKey       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\AllowTenantList'
            }
            $OneDriveRegKey = Remove-OneDriveRegKey @Remove_OneDriveRegKey
            $OneDriveRegKey.Invoke()
        }
    }


    if ($PSBoundParameters.Keys -contains 'BlockTenantList')
    {
        if ($BlockTenantList)
        {
            $i = 0
            foreach ($Tenant in $BlockTenantList)
            {
                $i++
                Registry "Policy_OneDrive_BlockTenantList_${i}"
                {
                    Ensure    = 'Present'
                    Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\BlockTenantList'
                    ValueName = $i
                    ValueType = 'String'
                    ValueData = $Tenant
                }
            }

            # Cleanup excess blocked tenants ...
            $Remove_OneDriveExcessRegKeyValues = @{
                InstanceName = 'Policy_OneDrive_BlockTenantList'
                RegKey       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\BlockTenantList'
                AllowedValueNames = (1..$i)
                DependsOn = ((1..$i) | ForEach-Object{ @() + @("[Registry]Policy_OneDrive_BlockTenantList_${_}") })
            }
            $OneDriveExcessRegKeyValues = Remove-OneDriveExcessRegKeyValues @Remove_OneDriveExcessRegKeyValues
            $OneDriveExcessRegKeyValues.Invoke()
        }
        else
        {
            $Remove_OneDriveRegKey = @{
                InstanceName = 'Policy_OneDrive_BlockTenantList'
                RegKey       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\BlockTenantList'
            }
            $OneDriveRegKey = Remove-OneDriveRegKey @Remove_OneDriveRegKey
            $OneDriveRegKey.Invoke()
        }
    }


    if ($FilesOnDemandEnabled)
    {
        Registry Policy_OneDrive_FilesOnDemandEnabled
        {
            Ensure    = $FilesOnDemandEnabled
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
            ValueName = 'FilesOnDemandEnabled'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($DehydrateSyncedTeamSites)
    {
        Registry Policy_OneDrive_DehydrateSyncedTeamSites
        {
            Ensure    = $DehydrateSyncedTeamSites
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
            ValueName = 'DehydrateSyncedTeamSites'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($PreventNetworkTrafficPreUserSignIn)
    {
        Registry Policy_OneDrive_PreventNetworkTrafficPreUserSignIn
        {
            Ensure    = $PreventNetworkTrafficPreUserSignIn
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
            ValueName = 'PreventNetworkTrafficPreUserSignIn'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($RemoteAccess32)
    {
        Registry Policy_OneDrive_RemoteAccess32
        {
            Ensure    = $RemoteAccess32
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\OneDrive\Remote Access'
            ValueName = 'GPOEnabled'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($RemoteAccess64)
    {
        Registry Policy_OneDrive_RemoteAccess64
        {
            Ensure    = $RemoteAccess64
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\OneDrive'
            ValueName = 'GPOEnabled'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($PSBoundParameters.Keys -contains 'AutomaticUploadBandwidthPercentage')
    {
        if ($AutomaticUploadBandwidthPercentage)
        {
            if
            (
                [int]$AutomaticUploadBandwidthPercentage -lt 10 -or
                [int]$AutomaticUploadBandwidthPercentage -gt 99
            ) {
                Throw [System.Management.Automation.ParameterBindingException] "[OneDrive] Policy_OneDrive_AutomaticUploadBandwidthPercentage Value Out of Range (0 or 10 to 99 inclusive): $($Threshold.Name): $($Threshold.Value)"
            }
            Registry Policy_OneDrive_AutomaticUploadBandwidthPercentage
            {
                Ensure    = 'Present'
                Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
                ValueName = 'AutomaticUploadBandwidthPercentage'
                ValueType = 'Dword'
                ValueData = $AutomaticUploadBandwidthPercentage
            }
        }
        else
        {
            Registry Policy_OneDrive_AutomaticUploadBandwidthPercentage
            {
                Ensure    = 'Absent'
                Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
                ValueName = 'AutomaticUploadBandwidthPercentage'
            }
        }
    }


    if ($SilentAccountConfig)
    {
        Registry Policy_OneDrive_SilentAccountConfig
        {
            Ensure    = $SilentAccountConfig
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive'
            ValueName = 'SilentAccountConfig'
            ValueType = 'Dword'
            ValueData = 1
        }
    }


    if ($PSBoundParameters.Keys -contains 'DiskSpaceCheckThresholdMB')
    {
        Write-Verbose "[OneDrive] Processing *DiskSpaceCheckThresholdMB* ..."
        if ($DiskSpaceCheckThresholdMB.Count)
        {
            $i = 0
            foreach ($Threshold in $DiskSpaceCheckThresholdMB.GetEnumerator())
            {
                Write-Verbose "[OneDrive] *DiskSpaceCheckThresholdMBDiskSpaceCheckThresholdMB* Threshold: $($Threshold | ConvertTo-Json -Compress)"
                if (-not ($Threshold.Name -as [guid]))
                {
                    Throw [System.Management.Automation.ParameterBindingException] "[OneDrive] Policy_OneDrive_DiskSpaceCheckThresholdMB Name should be a GUID: $($Threshold.Name)"
                }

                if (-not (($Threshold.Value -as [int64]) -is [int64])) # `-is [int64]` catches `0` as valid.
                {
                    Throw [System.Management.Automation.ParameterBindingException] "[OneDrive] Policy_OneDrive_DiskSpaceCheckThresholdMB Value must be of type [int64]: $($Threshold.Name): [$($Threshold.Value.GetType().FullName)] $($Threshold.Value)"
                }

                if (
                    [int64]$Threshold.Value -lt 0 -or
                    [int64]$Threshold.Value -gt 4294967295
                ) {
                    Throw [System.Management.Automation.ParameterBindingException] "[OneDrive] Policy_OneDrive_DiskSpaceCheckThresholdMB Value Out of Range (0 to 4294967295 inclusive): $($Threshold.Name): $($Threshold.Value)"
                }

                if (($Threshold.Value -as [int64]) -ne $Threshold.Value)
                {
                    Write-Warning "[OneDrive] Policy_OneDrive_DiskSpaceCheckThresholdMB Changed Value of '$($Threshold.Name)' from '[$($Threshold.Value.GetType().FullName)] $($Threshold.Value)' to '[$(($Threshold.Value -as [int64]).GetType().FullName)] $(($Threshold.Value -as [int64]))'"
                }

                Write-Verbose "[OneDrive] *DiskSpaceCheckThresholdMBDiskSpaceCheckThresholdMB* Threshold: Creating 'Registry' Resource ..."
                $i++
                Registry "Policy_OneDrive_DiskSpaceCheckThresholdMB_${i}"
                {
                    Ensure    = 'Present'
                    Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\DiskSpaceCheckThresholdMB'
                    ValueName = $Threshold.Name
                    ValueType = 'String'
                    ValueData = [int64]$Threshold.Value
                }
            }

            # Cleanup excess thresholds ...
            $Remove_OneDriveExcessRegKeyValues = @{
                InstanceName = 'Policy_OneDrive_DiskSpaceCheckThresholdMB'
                RegKey       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\DiskSpaceCheckThresholdMB'
                AllowedValueNames = $DiskSpaceCheckThresholdMB.Keys
                DependsOn = ((1..$i) | ForEach-Object{ @() + @("[Registry]Policy_OneDrive_DiskSpaceCheckThresholdMB_${_}") })
            }
            $OneDriveExcessRegKeyValues = Remove-OneDriveExcessRegKeyValues @Remove_OneDriveExcessRegKeyValues
            $OneDriveExcessRegKeyValues.Invoke()
        }
        else
        {
            Write-Verbose "[OneDrive] *DiskSpaceCheckThresholdMB* Removing ..."
            $Remove_OneDriveRegKey = @{
                InstanceName = 'Policy_OneDrive_DiskSpaceCheckThresholdMB'
                RegKey       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive\DiskSpaceCheckThresholdMB'
            }
            $OneDriveRegKey = Remove-OneDriveRegKey @Remove_OneDriveRegKey
            $OneDriveRegKey.Invoke()
        }
    }
}
