configuration Demo_Configuration {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'OneDriveDsc'

    Node localhost {
        OneDrive PreventNetworkTrafficPreUserSignIn_Present {
            PreventNetworkTrafficPreUserSignIn = 'Present'
        }
    }
}
