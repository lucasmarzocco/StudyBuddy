
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
import Firebase


class ViewController: UIViewController {
    
    let ref = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    let dictRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Dict")
    
    var profilePicture:UIImageView = UIImageView()
    var currentProfiles = [String]()
    var firstName: String!
    var lastName: String!
    var facebookID: NSString!
    
    //Sets image to Facebook profile picture image
    func returnUserInfo(accessToken: NSString, firstName: String, lastName: String)
    {
        let userID = accessToken as NSString
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
        
        if let data = NSData(contentsOfURL: facebookProfileUrl!) {
            self.profilePicture.image = UIImage(data: data)
            self.firstName = firstName
            self.lastName = lastName

            let groups: [String] = []
            let classes: [String] = []
            let notifications: [String] = []
            let id: String = facebookID as String
            
            if(!currentProfiles.contains(id)) {
                
                let newProfile = FacebookProfile(firstName: self.firstName, lastName: self.lastName, studyScore: 0, studyTitle: "Beginner", currentGroups: groups, currentClasses: classes, profilePic: facebookProfileUrl?.absoluteString, numberOfRatings: 0, id: facebookID, notifications: notifications)
            
                let profileRef = self.ref.childByAppendingPath(id)
                profileRef.setValue(newProfile.toAnyObject())
            }
        }
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email", "public_profile", "user_friends"], fromViewController: self) { (result, error) -> Void in

            if (error == nil) {
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                
                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }
        }
    }
    
    
    func getFBUserData() {
        
        if((FBSDKAccessToken.currentAccessToken()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil) {
                    if let id: NSString = result.valueForKey("id") as? NSString {
                        if let firstName: NSString = result.valueForKey("first_name") as? NSString {
                            if let lastName: NSString = result.valueForKey("last_name") as? NSString {
                                self.facebookID = id
                                self.addToFirebaseDictionary(self.facebookID, name: ((firstName as String) + " " + (lastName as String)))
                                self.returnUserInfo(id, firstName: firstName as String, lastName: lastName as String)
                                self.performSegueWithIdentifier("worked", sender: self)
                            }
                        }
                    }
                }
                
            })}
        
        else {
            logout(self)
        }
    }
    
    func addToFirebaseDictionary(id: NSString!, name: NSString!) {
        
        let dictRef = self.dictRef.childByAppendingPath(id as String)
        dictRef.setValue(name)
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
        logout(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            var profiles = [String]()
            
            for stuff in snapshot.children {
                let id = stuff.value.objectForKey("id") as! String
                profiles.append(id)
            }
            
            self.currentProfiles = profiles
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if(segue.identifier == "worked") {
            let dest = segue.destinationViewController.childViewControllers
            let bob = dest[0].childViewControllers[0] as! secondViewController
            bob.passedID = self.facebookID
            let bob1 = dest[1].childViewControllers[0] as! GroupViewController
            bob1.facebookID = self.facebookID
            let bob2 = dest[2].childViewControllers[0] as! NotificationViewController
            bob2.passedID = self.facebookID
        }
    }
}

