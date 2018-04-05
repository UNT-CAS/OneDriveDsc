Various DSC settings for the OneDrive sync client, especially for configuring settings specific to enterprise functionality in the client.

Can apply ~both~ computer ~and user~ policies with this resource.

# Parameters

## `AllowTenantList`

This setting lets you prevent users from easily uploading files to other organizations by specifying a list of allowed tenant IDs.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::AllowTenantList)

**Supported on:** At least Windows 7.

**Expected Value `[string[]]`:**
| Setting | Description |
|--|--|
| **`@('My Tenant', ...)`** | This will set `Ensure = 'Present'`, and OneDrive will allow all of the tenant IDs in this list. |
| **`@()`** | This will set `Ensure = 'Absent'`, and OneDrive will allow any tenant ID. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `BlockTenantList`

This setting lets you prevent users from easily uploading files to another organization by specifying a list of blocked tenant IDs.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::BlockTenantList)

**Supported on:** At least Windows 7.

**Expected Value `[string[]]`:**
| Setting | Description |
|--|--|
| **`@('My Tenant', ...)`** | This will set `Ensure = 'Present'`, and OneDrive will block all of the tenant IDs in this list. |
| **`@()`** | This will set `Ensure = 'Absent'`, and OneDrive will allow any tenant ID. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `FilesOnDemandEnabled`

This setting allows you to explicitly control whether OneDrive [Files On-Demand](https://support.office.com/en-us/article/learn-about-onedrive-files-on-demand-0e6860d3-d9f3-4971-b321-7092438fb38e) is enabled for your tenant.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::FilesOnDemandEnabled)

**Supported on:** At least Windows Server, Windows 10 Version 1709.

**Expected Value `[string]`:**
| Setting | Description |
|--|--|
| **`Present`** | This will set `Ensure = 'Present'`, and OneDrive will force this setting to be applied. |
| **`Absent`** | This will set `Ensure = 'Absent'`, and OneDrive will not have this setting applied. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `DehydrateSyncedTeamSites`

This policy applies if OneDrive Files On-Demand is enabled.
This policy enables you to migrate previously downloaded teamsite content to be Online-only.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::DehydrateSyncedTeamSites)

**Supported on:** At least Windows Server, Windows 10 Version 1709.

**Expected Value `[string]`:**
| Setting | Description |
|--|--|
| **`Present`** | This will set `Ensure = 'Present'`, and OneDrive will force this setting to be applied. |
| **`Absent`** | This will set `Ensure = 'Absent'`, and OneDrive will not have this setting applied. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `PreventNetworkTrafficPreUserSignIn`

Enable this setting to prevent the OneDrive sync client (OneDrive.exe) from generating network traffic (checking for updates, etc.) until the user signs in to OneDrive or starts syncing files to the local computer.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::PreventNetworkTrafficPreUserSignIn)

**Supported on:** At least Windows 7.

**Expected Value `[string]`:**
| Setting | Description |
|--|--|
| **`Present`** | This will set `Ensure = 'Present'`, and OneDrive will force this setting to be applied. |
| **`Absent`** | This will set `Ensure = 'Absent'`, and OneDrive will not have this setting applied. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `RemoteAccess32`

This setting allows you to block users from using the fetch feature when they are logged in to OneDrive.exe with their Microsoft account.
The fetch feature allows your users to go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive Sync Client, and access all their personal files from that computer. By default, users can use the fetch feature.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::RemoteAccess32)

*This setting is for computers running 32-bit versions of Windows.*

**Supported on:** At least Windows 7.

**Expected Value `[string]`:**
| Setting | Description |
|--|--|
| **`Present`** | This will set `Ensure = 'Present'`, and OneDrive will force this setting to be applied. |
| **`Absent`** | This will set `Ensure = 'Absent'`, and OneDrive will not have this setting applied. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `RemoteAccess64`

This setting allows you to block users from using the fetch feature when they are logged in to OneDrive.exe with their Microsoft account.
The fetch feature allows your users to go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive Sync Client, and access all their personal files from that computer. By default, users can use the fetch feature.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::RemoteAccess64)

*This setting is for computers running 64-bit versions of Windows.*

**Supported on:** At least Windows 7.

**Expected Value `[string]`:**
| Setting | Description |
|--|--|
| **`Present`** | This will set `Ensure = 'Present'`, and OneDrive will force this setting to be applied. |
| **`Absent`** | This will set `Ensure = 'Absent'`, and OneDrive will not have this setting applied. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `AutomaticUploadBandwidthPercentage`

This setting allows you to configure the maximum percentage of the available bandwidth on the computer that OneDrive sync will use to upload.
(OneDrive only uses this bandwidth when syncing files.)
The bandwidth available to a computer is constantly changing so a percentage allows sync to respond to both increases and decreases in bandwidth availability while syncing in the background.
The lower the percentage of bandwidth OneDrive sync is allowed to take, the slower the computer will sync files.
Microsoft recommends a value of 50% or higher.
Sync enables upload limiting by periodically allowing the sync engine to go full speed for one minute and then slowing down to the upload percentage set by this setting. This enables two key scenarios.
First, a very small file will get uploaded quickly because it can fit in the interval where sync is measuring the maximum possible speed.
Second, for any long running upload, sync will keep optimizing the upload speed per the percentage value set by this setting.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::AutomaticUploadBandwidthPercentage)

**Supported on:** At least Windows 7.

**Expected Value `[int]`:**
| Setting | Description |
|--|--|
| **`10` - `99`** | This will set `Ensure = 'Present'`, and OneDrive will force this setting to be applied. |
| **`0`** | This will set `Ensure = 'Absent'`, and OneDrive will not have this setting applied. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `SilentAccountConfig`

This setting allows you to configure OneDrive silently using the primary Windows account.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::SilentAccountConfig)

**Supported on:** At least Windows 7.

**Expected Value `[string]`:**
| Setting | Description |
|--|--|
| **`Present`** | This will set `Ensure = 'Present'`, and OneDrive will force this setting to be applied. |
| **`Absent`** | This will set `Ensure = 'Absent'`, and OneDrive will not have this setting applied. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

## `DiskSpaceCheckThresholdMB`

This setting is used in conjunction with [SilentAccountConfig](#silentaccountconfig).
Any user who has a OneDrive for Business that is larger than the specified threshold (in MB) will be prompted to choose the folders they would like to sync before OneDrive downloads the files.
[More Info...](https://getadmx.com/?Category=OneDrive&Policy=Microsoft.Policies.OneDriveNGSC::DiskSpaceCheckThresholdMB)

**Supported on:** At least Windows 7.

**Expected Value `[hashtable]`:**
| Setting | Description |
|--|--|
| **`@{TenantGUID = 1234; ...}`** | This will set `Ensure = 'Present'`, and OneDrive will force this setting to be applied. <ul><li>**`TenantGUID`**: Tenant guid must be a `[string]` in proper `[guid]` form; such as: `'d84f007b-51f6-4470-a50b-3ec6b2351977'`</li><li>**`1234`**: Is an `[int]` representing the threshold in MB. Valid values are from `0` to `4294967295` MB (inclusive).</li></ul> |
| **`@{}`** | This will set `Ensure = 'Absent'`, and OneDrive will not have this setting applied. |
| **Not Set** | This will not be managed. This will not undo previously set settings; you may want to *ensure absent* for that. |

# Examples

## Via [Datum](https://github.com/gaelcolas/Datum) YAML

```yaml
cOneDrive
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
  cOneDrive `
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
  $cOneDrive = @{
    AllowTenantList = @('UNT CAS')
    DehydrateSyncedTeamSites = 'Present'
    FilesOnDemandEnabled = 'Present'
    PreventNetworkTrafficPreUserSignIn = 'Present'
    SilentAccountConfig = 'Present'
  }
  cOneDrive @cOneDrive
}
```

## Set AllowTenantList to Absent

```powershell
cOneDrive -AllowTenantList @()
```

# Notes

https://getadmx.com/?Category=OneDrive
