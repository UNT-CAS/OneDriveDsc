Various DSC settings for the OneDrive sync client, especially for configuring settings specific to enterprise functionality in the client.

Can apply ~both~ computer ~and user~ policies with this resource.

# Parameters

## `AllowTenantList`

This setting lets you prevent users from easily uploading files to other organizations by specifying a list of allowed tenant IDs.

If you enable this setting, users will get an error if they attempt to add an account from an organization that is not allowed. If a user has already added the account, the files will stop syncing.

If you disable or do not configure this setting, users can add accounts from any organization.

To block specific organizations instead, use "Block syncing OneDrive accounts for specific organizations."

This setting will take priority over the policy "Block syncing OneDrive accounts for specific organizations." Do not enable both policies at the same time.

Supported on: At least Windows 7. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::AllowTenantList

## `BlockTenantList`

This setting lets you prevent users from easily uploading files to another organization by specifying a list of blocked tenant IDs.

If you enable this setting, users will get an error if they attempt to add an account from an organization that is blocked. If a user has already added the account, the files will stop syncing.

If you disable or do not configure this setting, users can add accounts from any organization.

To specify a list of allowed organizations instead, use "Allow syncing OneDrive accounts for only specific organizations."

This setting will NOT work if you have the policy "Allow syncing OneDrive accounts for only specific organizations." enabled. Do not enable both policies at the same time.

Supported on: At least Windows 7. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::BlockTenantList

## `FilesOnDemandEnabled`

This setting allows you to explicitly control whether OneDrive Files On-Demand is enabled for your tenant.

If you enable this setting, OneDrive Files On-Demand will be turned ON by default for all users the policy is applied to.

If you disable this setting, OneDrive Files On-Demand will be explicitly disabled and a user cannot turn it on.

If you do not configure this setting, OneDrive Files On-Demand can be either turned on or off by a user. 

Supported on: At least Windows Server, Windows 10 Version 1709. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::FilesOnDemandEnabled

## `DehydrateSyncedTeamSites`

This policy applies if OneDrive Files On-Demand is enabled.

This policy enables you to migrate previously downloaded teamsite content to be Online-only.

If you enable this policy, teamsites that were syncing before OneDrive Files On-Demand was enable will be transitioned to Online-only by default. 

This is ideal for cases where you want to conserve bandwidth and have many PCs syncing the same TeamSite. 

Supported on: At least Windows Server, Windows 10 Version 1709. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::DehydrateSyncedTeamSites

## `PreventNetworkTrafficPreUserSignIn`

Enable this setting to prevent the OneDrive sync client (OneDrive.exe) from generating network traffic (checking for updates, etc.) until the user signs in to OneDrive or starts syncing files to the local computer.

If you enable this setting, users must sign in to the OneDrive sync client on the local computer, or select to sync OneDrive or SharePoint files on the computer, for the sync client to start automatically.

If this setting is not enabled, the OneDrive sync client will start automatically when users sign in to Windows.

If you enable or disable this setting, do not return the setting to Not Configured. Doing so will not change the configuration and the last configured setting will remain in effect.

Supported on: At least Windows 7. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::PreventNetworkTrafficPreUserSignIn

## `RemoteAccess32`

This setting allows you to block users from using the fetch feature when they are logged in to OneDrive.exe with their Microsoft account. The fetch feature allows your users to go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive Sync Client, and access all their personal files from that computer. By default, users can use the fetch feature.

If you enable this setting, users will be prevented from using the fetch feature.

If you disable this setting, users can use the fetch feature.

This setting is for computers running 32-bit versions of Windows. 

Supported on: At least Windows 7. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::RemoteAccess32

## `RemoteAccess64`

This setting allows you to block users from using the fetch feature when they are logged in to OneDrive.exe with their Microsoft account. The fetch feature allows your users to go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive Sync Client, and access all their personal files from that computer. By default, users can use the fetch feature.

If you enable this setting, users will be prevented from using the fetch feature.

If you disable this setting, users can use the fetch feature.

This setting is for computers running 64-bit versions of Windows. 

Supported on: At least Windows 7. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::RemoteAccess64

## `AutomaticUploadBandwidthPercentage`

This setting allows you to configure the maximum percentage of the available bandwidth on the computer that OneDrive sync will use to upload. (OneDrive only uses this bandwidth when syncing files.) The bandwidth available to a computer is constantly changing so a percentage allows sync to respond to both increases and decreases in bandwidth availability while syncing in the background. The lower the percentage of bandwidth OneDrive sync is allowed to take, the slower the computer will sync files. We recommend a value of 50% or higher. Sync enables upload limiting by periodically allowing the sync engine to go full speed for one minute and then slowing down to the upload percentage set by this setting. This enables two key scenarios. First, a very small file will get uploaded quickly because it can fit in the interval where sync is measuring the maximum possible speed. Second, for any long running upload, sync will keep optimizing the upload speed per the percentage value set by this setting.

If you enable this setting, computers affected by this policy will use the maximum bandwidth percentage that you specify.

If you disable this setting, computers will allow the users to determine how much upload bandwidth they can use.

If you enable or disable this setting, do not return the setting to Not Configured. Doing so will not change the configuration and the last configured setting will remain in effect.

Supported on: At least Windows 7. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::AutomaticUploadBandwidthPercentage

## `SilentAccountConfig`

This setting allows you to configure OneDrive silently using the primary Windows account.

If you enable this setting, OneDrive will attempt to sign in to OneDrive for Business using these credentials. OneDrive will check the space on disk before syncing, and if it is large OneDrive will prompt the user to choose their folders. The threshold for which the user is prompted can be configured using DiskSpaceCheckThresholdMB. OneDrive will attempt to sign in on every account on the machine and once successful, that account will no longer attempt silent configuration.

If you enable this setting, ADAL must be enabled or the account configuration will fail.

If you enable this setting and the user is using the legacy OneDrive for Business sync client, the new client will attempt to take over sync from the legacy client. If successful OneDrive will persist the user's sync settings from the legacy client.

If you disable this setting, OneDrive will not attempt to automatically sign in users.

Other settings which are useful with SilentAccountConfig include DiskSpaceCheckThresholdMB, and DefaultRootDir. 

Supported on: At least Windows 7. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::SilentAccountConfig

## `DiskSpaceCheckThresholdMB`

This setting is used in conjunction with SilentAccountConfig. Any user who has a OneDrive for Business that is larger than the specified threshold (in MB) will be prompted to choose the folders they would like to sync before OneDrive downloads the files. 

Supported on: At least Windows 7. More Info: https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::DiskSpaceCheckThresholdMB

# Example

## Via [Datum](https://github.com/gaelcolas/Datum) YAML

```yaml
xOneDrive
  AllowTenantList:
    - UNT CAS
  DehydrateSyncedTeamSites: Present
  FilesOnDemandEnabled: Present
  PreventNetworkTrafficPreUserSignIn: Present
  SilentAccountConfig: Present
```

## Via Powershell

```powershell
Node 'localhost' {
  xOneDrive `
    -AllowTenantList @('UNT CAS') `
    -DehydrateSyncedTeamSites 'Present' `
    -FilesOnDemandEnabled 'Present' `
    -PreventNetworkTrafficPreUserSignIn 'Present' `
    -SilentAccountConfig 'Present'
}
```

## Via Powershell Splatting

```powershell
Node 'localhost' {
  $xOneDrive = @{
    AllowTenantList = @('UNT CAS')
    DehydrateSyncedTeamSites = 'Present'
    FilesOnDemandEnabled = 'Present'
    PreventNetworkTrafficPreUserSignIn = 'Present'
    SilentAccountConfig = 'Present'
  }
  xOneDrive @xOneDrive
}
```

## Set AllowTenantList to Absent

```powershell
xOneDrive -AllowTenantList @()
```

# Notes

https://getadmx.com/?Category=OneDrive
