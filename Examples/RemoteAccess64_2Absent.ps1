configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive RemoteAccess64_Absent {
            RemoteAccess64 = 'Absent'
        }
    }
}
