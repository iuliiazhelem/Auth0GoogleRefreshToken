# Auth0GoogleRefreshToken

This sample exposes how to get Google refresh token using Lock.

In some scenarios, you might want to access Google APIs from your application. You do that by using the access_token stored on the identities array (user.identities[0].access_token). However access_tokens have an expiration and in order to get a new one, you have to ask the user to login again. That's why Google allows asking for a refresh_token that can be used forever (until the user revokes it) to obtain new access_tokens without requiring the user to relogin. The way you ask for a refresh_token using Lock is by sending the access_type=offline as an extra parameter.
Important: When your application receives a refresh token, it is important to store that refresh token for future use. If your application loses the refresh token, it will have to re-prompt the user for consent before obtaining another refresh token. If you need to re-prompt the user for consent, include the prompt parameter in the authorization code request, and set the value to consent. So for testing you can add parameter "prompt" : "consent" to your authenticate request.

For this you need to add the following to your `Podfile`:
```
pod 'Lock', '~> 1.24'
pod 'SimpleKeychain'
```

## Important snippets

### Step 1: Register the Authenticator 
```swift
let google = A0WebViewAuthenticator(connectionName: "google-oauth2", lock: A0Lock.sharedLock())
A0Lock.sharedLock().registerAuthenticators([google]);
```

```Objective-C
A0Lock *lock = [A0Lock sharedLock];
A0WebViewAuthenticator *google = [[A0WebViewAuthenticator alloc] initWithConnectionName:@"google-oauth2" lock:lock];
[lock registerAuthenticators:@[google]];
```

### Step 2: Authenticate with a Connection name "google-oauth2"
```swift
let success = { (profile: A0UserProfile, token: A0Token) in
  print("User: \(profile)")
}
let failure = { (error: NSError) in
  print("Oops something went wrong: \(error)")
}
let lock = A0Lock.sharedLock()
let parameters = A0AuthParameters(dictionary: [A0ParameterScope : [A0ScopeProfile, A0ScopeOfflineAccess], "access_type" : "offline", "prompt" : "consent"])

lock.identityProviderAuthenticator().authenticateWithConnectionName("google-oauth2", parameters: parameters, success: success, failure: failure)
```

```Objective-C
void(^success)(A0UserProfile *, A0Token *) = ^(A0UserProfile *profile, A0Token *token) {
  NSLog(@"User: %@", profile);
};
void(^error)(NSError *) = ^(NSError *error) {
  NSLog(@"Oops something went wrong: %@", error);
};
  
A0Lock *lock = [A0Lock sharedLock];
A0AuthParameters *parameters = [A0AuthParameters newWithScopes:@[A0ScopeProfile, A0ScopeOfflineAccess]];
parameters[@"access_type"] = @"offline";
params[@"prompt"] = @"consent";

[[lock identityProviderAuthenticator] authenticateWithConnectionName:connectionName
                                                          parameters:parameters
                                                             success:success
                                                             failure:error];
```

### Step 3: Additional call to get raw user data (not A0UserProfile). It is GET request with url "https://<Auth0 Domain>/userinfo" and header "Authorization : Bearer <accessToken>". You need to use accessToken from previous step.

```Swift
let userDomain = (NSBundle.mainBundle().infoDictionary!["Auth0Domain"]) as! String
let urlString = "https://\(userDomain)/userinfo"
let url = NSURL(string: urlString)
if let actualUrl = url {
  let request = NSMutableURLRequest(URL: actualUrl)
  request.HTTPMethod = "GET";
  request.allHTTPHeaderFields = ["Authorization" : "Bearer \(actualAccessToken)"]
                
  NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data : NSData?, response : NSURLResponse?, error : NSError?) in
  // Check if data was received successfully
  if error == nil && data != nil {
    do {
      // Convert NSData to Dictionary where keys are of type String, and values are of any type
      let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
      if let refreshToken = json["identities"]![0]["refresh_token"], let actRefreshToken = refreshToken {
        print("actRefreshToken: \(actRefreshToken)")
      } else {
        print("There is no refresh_token in userProfile")
      }
    } catch {
      let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
      print("Oops something went wrong: \(dataString)")
    }
  } else {
    print("Oops something went wrong: \(error)")
  }
  }).resume()
} else {
  print("Incorrect url")
}
```
```Objective_c
NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
NSString *urlString = [NSString stringWithFormat:@"https://%@/userinfo", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Auth0Domain"]];
NSURL *url = [NSURL URLWithString:urlString];
    
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:10.0];
[request setHTTPMethod:@"GET"];
[request setAllHTTPHeaderFields:headers];
    
NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error) {
                                                  NSLog(@"%@", error);
                                                } else {
                                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                                  NSString *refresh_token = dict[@"isentities"][0][@"refresh_token"];
                                                  NSLog(@"refresh_token : %@", refresh_token);
                                                }
                                            }];
[dataTask resume];
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

For more information about Google refresh token please check the following link:
* [Google Identity Offline access](https://developers.google.com/identity/protocols/OAuth2WebServer#offline)
