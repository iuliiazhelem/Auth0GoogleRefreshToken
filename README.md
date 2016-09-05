# Auth0GoogleRefreshToken
Test example for getting Google refresh token

This sample exposes how to integrate social connections into your application (Microsoft, Google, Twitter, LinkedIn, Instagram) using Auth0.

For this you need to add the following to your `Podfile`:
```
pod 'Lock', '~> 1.24'
pod 'Lock-Twitter', '~> 1.1'
pod 'Lock-Google', '~> 2.0'
pod 'GoogleUtilities', '1.1.0'
pod 'SimpleKeychain'
```

Before using the example please make sure that you change some keys in the `Info.plist` file with your data:

##### Auth0 data from [Auth0 Dashboard](https://manage.auth0.com/#/applications):

- Auth0ClientId
- Auth0Domain
- CFBundleURLSchemes

```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>auth0</string>
<key>CFBundleURLSchemes</key>
<array>
<string>a0{CLIENT_ID}</string>
</array>
```

##### For configuring Google authentication you need to download your own `GoogleServices-Info.plist` file from [this wizard](https://developers.google.com/mobile/add?platform=ios) and replace it with existing file. Also please find REVERSED_CLIENT_ID in this file and add it to CFBundleURLSchemes. For more details about connecting your app to Google see [this link](https://auth0.com/docs/connections/social/google) and [this iOS doc](https://auth0.com/docs/libraries/lock-ios/native-social-authentication#google):

- CFBundleURLSchemes

```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>Google</string>
<key>CFBundleURLSchemes</key>
<array>
<string>{REVERSED_CLIENT_ID}</string>
</array>
```
