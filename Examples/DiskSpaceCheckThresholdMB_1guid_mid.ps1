configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive DiskSpaceCheckThresholdMB_1guid_mid {
            DiskSpaceCheckThresholdMB = @{
                '79cc8d16-7756-4199-bff4-216a15619d53' = 2021530592
            }
        }
    }
}
