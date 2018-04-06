configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive AutomaticUploadBandwidthPercentage_99 {
            AutomaticUploadBandwidthPercentage = 99
        }
    }
}
