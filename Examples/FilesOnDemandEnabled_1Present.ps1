configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive FilesOnDemandEnabled_Present {
            FilesOnDemandEnabled = 'Present'
        }
    }
}
