//
//  ViewController.swift
//  AKAuth0TestApp
//

import UIKit
import Lock

let kGoogleConnectionName = "google-oauth2"

class ViewController: UIViewController {

    // Step 1: Login to Google with additional parameter "access_type" = "offline"
    @IBAction func clickGoogleButton(sender: AnyObject) {
        let success:A0IdPAuthenticationBlock = { (profile, token) in
            print("profile : \(profile)")
            
            //Additional call to get raw user data (not A0UserProfile) which will contain refresh_token
            self.getUserProfileWithAccessToken(token.accessToken)
        }
            
        let failure = { (error: NSError) in
            print("Oops something went wrong: \(error)")
        }
        
        let parameters = A0AuthParameters(dictionary: [A0ParameterScope : [A0ScopeProfile, A0ScopeOfflineAccess], "access_type" : "offline", "prompt" : "consent"])
        
        //"prompt" : "consent" - was added for testing
        //https://developers.google.com/identity/protocols/OAuth2WebServer#offline
        //Important: When your application receives a refresh token, it is important to store that refresh token for future use. If your application loses the refresh token, it will have to re-prompt the user for consent before obtaining another refresh token. If you need to re-prompt the user for consent, include the prompt parameter in the authorization code request, and set the value to consent.
        
        A0Lock.sharedLock().identityProviderAuthenticator().authenticateWithConnectionName(kGoogleConnectionName, parameters: parameters, success:success, failure: failure)
        
    }
    
    // Step 2: Get raw JSON with user data
    func getUserProfileWithAccessToken(accessToken:String?) -> Void {
        // GET request
        // We need url "https://<Auth0 Domain>/userinfo"
        // and header "Authorization : Bearer <accessToken>"
        
        if let actualAccessToken = accessToken {
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
                            print("\(json)")
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
            }
        }
    }
}

