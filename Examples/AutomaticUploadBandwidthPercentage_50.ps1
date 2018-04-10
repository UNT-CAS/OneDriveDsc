configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive AutomaticUploadBandwidthPercentage_50 {
            AutomaticUploadBandwidthPercentage = 50
        }
    }
}
