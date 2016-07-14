//
//  ViewController.swift
//  AKAuth0TestApp
//
//  Created by Iuliia Zhelem on 14.07.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

import UIKit
import Lock

let kGoogleConnectionName = "google-oauth2"

class ViewController: UIViewController {

    @IBAction func clickGoogleButton(sender: AnyObject) {
        let success:A0IdPAuthenticationBlock = { (profile, token) in
            //additional call to get raw user data (not A0UserProfile)
            self.getUserProfileWithAccessToken(token.accessToken)
            
            //or if you have replaced A0UserIdentity with changed files 
            //from the folder Auth0GoogleRefreshToken/Identity
            //if let firstIdentity = profile.identities.first, let googleRefreshToken = firstIdentity.refreshToken {
            //use googleAccessToken here...
            //}
        }
            
        let failure = { (error: NSError) in
            print("Oops something went wrong: \(error)")
            
        }
        
         let connectionScopes = [kGoogleConnectionName : [
            "https://www.googleapis.com/auth/gmail.readonly",
            "https://www.googleapis.com/auth/calendar.readonly",
            "https://www.googleapis.com/auth/drive.readonly",
            "https://www.googleapis.com/auth/contacts.readonly"
            
            ]]
        let parameters = A0AuthParameters(dictionary: [A0ParameterScope : [A0ScopeProfile, A0ScopeOfflineAccess],
            A0ParameterConnectionScopes : connectionScopes, A0ParameterConnection : kGoogleConnectionName,"access_type" : "offline", "prompt" : "consent"])
        
        //"prompt" : "consent" - was added for testing
        //https://developers.google.com/identity/protocols/OAuth2WebServer#offline
        //Important: When your application receives a refresh token, it is important to store that refresh token for future use. If your application loses the refresh token, it will have to re-prompt the user for consent before obtaining another refresh token. If you need to re-prompt the user for consent, include the prompt parameter in the authorization code request, and set the value to consent.
        
        A0Lock.sharedLock().identityProviderAuthenticator().authenticateWithConnectionName(kGoogleConnectionName, parameters: parameters, success:success, failure: failure)
        
    }
    
    func getUserProfileWithAccessToken(accessToken:String?) -> Void {
        if let actualAccessToken = accessToken {
            // GET request
            // We need url "https://<Auth0 Domain>/userinfo"
            // and header "Authorization : Bearer <accessToken>"
            
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
        } else {
            
            print("Incorrect token");
        }
    }
}

