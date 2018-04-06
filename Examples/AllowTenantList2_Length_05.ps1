configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive AllowTenantList_Length_5 {
            AllowTenantList = @(
                'UNT CAS',
                'Test Tenant',
                'Foo Bar',
                'Hello World',
                'Bar Baz'
            )
        }
    }
}
