configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive AllowTenantList_Length_1 {
            AllowTenantList = @('UNT CAS')
        }
    }
}
