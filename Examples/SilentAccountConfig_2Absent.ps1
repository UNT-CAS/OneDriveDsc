configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive SilentAccountConfig_Absent {
            SilentAccountConfig = 'Absent'
        }
    }
}
