# Auth0GoogleRefreshToken

This sample exposes how to get Google refresh token using Lock.

In some scenarios, you might want to access Google APIs from your application. You do that by using the access_token stored on the identities array (user.identities[0].access_token). However access_tokens have an expiration and in order to get a new one, you have to ask the user to login again. That's why Google allows asking for a refresh_token that can be used forever (until the user revokes it) to obtain new access_tokens without requiring the user to relogin. The way you ask for a refresh_token using Lock is by sending the access_type=offline as an extra parameter.
The only caveat is that Google will send you the refresh_token only once, and if you haven't stored it, you will have to ask for it again and add approval_prompt=force so the user explicitly consent again.

For this you need to add the following to your `Podfile`:
```
pod 'Lock', '~> 1.24'
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

For more details please look at links:
* [Google Identity Offline access](https://developers.google.com/identity/protocols/OAuth2WebServer#offline)
* 
