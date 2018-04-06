configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive DiskSpaceCheckThresholdMB_2guid_max {
            DiskSpaceCheckThresholdMB = @{
                '1dc9d139-34e8-45cd-a07d-77fdd31bdc1e' = 1853250007
                '195568ed-5e16-4dd4-a3a5-6f9a478896b0' = 4294967295
            }
        }
    }
}
