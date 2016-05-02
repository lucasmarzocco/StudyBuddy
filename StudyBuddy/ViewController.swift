//
//  ViewController.swift
//  StudyBuddy
//
//  Created by Lucas Marzocco on 4/3/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController {
    
    var profilePicture:UIImageView = UIImageView()
    var firstName:NSString!
    var lastName:NSString!
    
    
    //Sets image to Facebook profile picture image
    func returnUserInfo(accessToken: NSString, firstName: NSString, lastName: NSString)
    {
        let userID = accessToken as NSString
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
        
        if let data = NSData(contentsOfURL: facebookProfileUrl!) {
            self.profilePicture.image = UIImage(data: data)
            self.firstName = firstName
            self.lastName = lastName
        }
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["email", "user_friends"], fromViewController: self) { (result, error) -> Void in
            
            if (error == nil) {
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    
    func getFBUserData() {
        
        if((FBSDKAccessToken.currentAccessToken()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, user_friends, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil) {
                    
                    if let id: NSString = result.valueForKey("id") as? NSString {
                        if let firstName: NSString = result.valueForKey("first_name") as? NSString {
                            if let lastName: NSString = result.valueForKey("last_name") as? NSString {
                                self.returnUserInfo(id, firstName: firstName, lastName: lastName)
                            }
                        }
                    }
                }
                
                    self.performSegueWithIdentifier("worked", sender: self)
                })
            }
    }
    
    @IBAction func logout(sender: AnyObject) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    @IBAction func logoutNow(segue: UIStoryboardSegue) {
        logout(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

