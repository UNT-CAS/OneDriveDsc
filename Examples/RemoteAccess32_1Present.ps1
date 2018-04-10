configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive RemoteAccess32_Present {
            RemoteAccess32 = 'Present'
        }
    }
}
