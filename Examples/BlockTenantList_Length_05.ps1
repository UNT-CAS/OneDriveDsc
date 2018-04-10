configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive BlockTenantList_Length_5 {
            BlockTenantList = @(
                'UNT CAS',
                'Test Tenant',
                'Foo Bar',
                'Hello World',
                'Bar Baz'
            )
        }
    }
}
