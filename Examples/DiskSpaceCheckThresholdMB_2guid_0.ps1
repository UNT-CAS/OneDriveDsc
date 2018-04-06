configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive DiskSpaceCheckThresholdMB_2guid_0 {
            DiskSpaceCheckThresholdMB = @{
                '0a4530c2-d071-48d8-a692-156365d9369d' = 3291342
                '9b5eb071-4417-4ebe-b890-8e7aa2ecfecd' = 0
            }
        }
    }
}
