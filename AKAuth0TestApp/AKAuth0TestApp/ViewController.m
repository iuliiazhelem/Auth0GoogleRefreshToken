//
//  ViewController.m
//  AKAuth0TestApp
//

#import "ViewController.h"
#import <Lock/Lock.h>

static NSString *kGoogleConnectionName = @"google-oauth2";

@interface ViewController ()

- (IBAction)clickGoogleButton:(id)sender;
@end

@implementation ViewController

// Step 1: Login to Google with additional parameter "access_type" = "offline"
- (IBAction)clickGoogleButton:(id)sender {
    A0Lock *lock = [A0Lock sharedLock];
    
    void(^success)(A0UserProfile *, A0Token *) = ^(A0UserProfile *profile, A0Token *token) {
        NSLog(@"profile : %@", profile);
        
        //Additional call to get raw user data (not A0UserProfile) which will contain refresh_token
        [self getUserProfileWithAccessToken:token.accessToken];
    };

    void(^failure)(NSError *) = ^(NSError *error) {
        NSLog(@"Oops something went wrong: %@", error);
    };

    A0AuthParameters *parameters = [A0AuthParameters newWithScopes:@[A0ScopeProfile, A0ScopeOfflineAccess]];
    parameters[A0ParameterConnection] = kGoogleConnectionName;
    parameters[@"access_type"] = @"offline";
    parameters[@"prompt"] = @"consent";
    
    //"prompt" : "consent" - was added for testing
    //https://developers.google.com/identity/protocols/OAuth2WebServer#offline
    //Important: When your application receives a refresh token, it is important to store that refresh token for future use. If your application loses the refresh token, it will have to re-prompt the user for consent before obtaining another refresh token. If you need to re-prompt the user for consent, include the prompt parameter in the authorization code request, and set the value to consent.
    
    [[lock identityProviderAuthenticator] authenticateWithConnectionName: kGoogleConnectionName
                                                              parameters: parameters
                                                                 success:success
                                                                 failure: failure];
}

// Step 2: Get raw JSON with user data
- (void)getUserProfileWithAccessToken:(NSString *)accessToken {
    // GET request
    // We need url "https://<Auth0 Domain>/userinfo"
    // and header "Authorization : Bearer <accessToken>"

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
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                                        NSLog(@"%@", dict);
                                                        NSString *refresh_token = dict[@"isentities"][0][@"refresh_token"];
                                                        NSLog(@"refresh_token : %@", refresh_token);
                                                    }
                                                }];
    [dataTask resume];
}

@end
