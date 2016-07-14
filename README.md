# Auth0GoogleRefreshToken
Test example for getting Google refresh token

Please make sure that you change file GoogleService-Info.plist and some keys in Info.plist with your data:
- Auth0ClientId
- Auth0Domain
- CFBundleURLTypes

<key>CFBundleURLTypes</key>
<array>
<dict>
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>auth0</string>
<key>CFBundleURLSchemes</key>
<array>
<string>a0pj1N9W644zMIyI62UZqNIFnYCdsnwt9V</string>
</array>
</dict>
<dict>
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>Google</string>
<key>CFBundleURLSchemes</key>
<array>
<string>com.googleusercontent.apps.514652084725-lbq4ulvpadvb4mmumqg7q3b46mvnshcd</string>
</array>
</dict>
<dict>
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLSchemes</key>
<array>
<string>com.akvelon.AKAuth0TestApp</string>
</array>
</dict>
</array>

a0pj1N9W644zMIyI62UZqNIFnYCdsnwt9V -> a0<Auth0ClientId>

com.googleusercontent.apps.514652084725-lbq4ulvpadvb4mmumqg7q3b46mvnshcd - com.googleusercontent.apps.<GoogleClientId> 

com.akvelon.AKAuth0TestApp - your bundle identifier
