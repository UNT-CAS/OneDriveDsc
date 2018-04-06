configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive AllowTenantList_Length_10 {
            AllowTenantList = @(
                'UNT CAS',
                'Test Tenant',
                'Foo Bar',
                'Hello World',
                'Bar Baz',
                'Lorem ipsum',
                'dolor sit',
                'amet, consectetur',
                'adipiscing elit',
                'Aliquam auctor'
            )
        }
    }
}
