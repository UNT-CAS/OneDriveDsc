configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive BlockTenantList_Length_1 {
            BlockTenantList = @('UNT CAS')
        }
    }
}
