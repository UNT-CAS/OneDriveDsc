configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive BlockTenantList_Length_10 {
            BlockTenantList = @(
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
