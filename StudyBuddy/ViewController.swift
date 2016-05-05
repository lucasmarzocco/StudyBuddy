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
    
    var profilePicture:UIImageView = UIImageView()
    var firstName: String!
    var lastName: String!
    var currentProfiles = [String]()
    let ref = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
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

            let groups: [String] = [""]
            let classes: [String] = [""]
            
            if(!currentProfiles.contains(firstName + lastName)) {

                print("New shit added!!!")
                let newProfile = FacebookProfile(firstName: self.firstName, lastName: self.lastName, studyScore: 1, studyTitle: "Beginner", currentGroups: groups, currentClasses: classes, profilePic: facebookProfileUrl?.absoluteString, ref: self.ref.description, id: facebookID, classBoolean: true)
            
                let profileRef = self.ref.childByAppendingPath(firstName + " " + lastName)
                profileRef.setValue(newProfile.toAnyObject())
            }
        }
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()

        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) -> Void in
            
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
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if (error == nil) {
                    if let id: NSString = result.valueForKey("id") as? NSString {
                        if let firstName: NSString = result.valueForKey("first_name") as? NSString {
                            if let lastName: NSString = result.valueForKey("last_name") as? NSString {
                                self.storeID(id)
                                self.returnUserInfo(id, firstName: firstName as String, lastName: lastName as String)
                                self.performSegueWithIdentifier("worked", sender: self)
                            }
                        }
                    }
                }
              })
            }
    }
    
    func storeID(id: NSString) {
        self.facebookID = id
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
                
                let firstName = stuff.value.objectForKey("firstName") as! String
                let lastName = stuff.value.objectForKey("lastName") as! String
                
                profiles.append(firstName + lastName)
            }
            
            self.currentProfiles = profiles
            
            }, withCancelBlock: { error in
                print("An error has occurred")
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
            
            if(bob.passedID == nil) {
                print ("ID is null for now")
            }
            bob.passedID = self.facebookID
        }
    }
}

