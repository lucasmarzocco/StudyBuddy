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
    
    
    /*@IBOutlet weak var button: FBSDKLoginButton!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stindr: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var classButton: UIButton!
    @IBOutlet var wordField: UITextField? */
    
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
                                self.returnUserInfo(id, firstName: firstName, lastName: lastName)
                            }
                        }
                    }
                }
                
                    self.performSegueWithIdentifier("worked", sender: self)
                })
            }
    }
    
    

    
        
    
    //Test String array for classes
   /* var items: [String] = ["ECE 158B", "COGS 185", "ENG 100D", "CSE 190", "CSE 250A"]
    
    
    //Add new class to the list
    func wordEntered(alert: UIAlertAction!) {
        
        //Adds the string in uppercase format, no matter what user inputs
        if items.contains(self.wordField!.text!.uppercaseString) {
        
            sendAlert("Duplicate Entry", message: "Class already has been added!")
        
        }
        else {
            items.append(self.wordField!.text!.uppercaseString)
            filterList()
        }
    }
    
    //Text field for adding classes
    func addTextField(textField: UITextField!) {
        self.wordField = textField
    }
    
    //Sorts class list
    func filterList() {
        items.sortInPlace() { $0 < $1 }
        tableView.reloadData()
    } */
    
    
    
    //Alert function that shows pop up alerts to the user
   /* func sendAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    } */
    
    
    
    //Brings up a popup to add your class
   /* @IBAction func buttonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Class Name", message: "Add your class", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(addTextField)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: wordEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)
    } */
    
    //For when the view loads originally
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*//Log out if previously logged in
        loginButtonDidLogOut(button)
        
        self.stindr.hidden = false
        self.tableView.hidden = true
        self.classButton.hidden = true;
        self.name.text = "Please sign in above!"
        
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in..")
        }
        else
        {
            print("Logged in..")
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends", "read_custom_friendlists"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.allowsSelection = true
        filterList() */
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "worked") {
            let secondController = segue.destinationViewController
            secondController.profPic = self.profilePicture
            secondController.firstName = firstName
            secondController.lastName = lastName
        }
    } */
    
    

    //Returns Facebook first name and last name
    
    /*
    func returnFirstName(firstName: NSString, lastName: NSString) {
        
        self.name.text = "Welcome, \(firstName) \(lastName)!"
        self.stindr.hidden = true
        tableView.hidden = false;
        classButton.hidden = false;
    }
    
    //Deals with the whole login button and grabs the information
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil
        {
            print("Login complete.")
            name.text = "Welcome!"
            
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    print("Error: \(error)")
                }
                else
                {
                    if let id: NSString = result.valueForKey("id") as? NSString {
                        self.returnUserProfileImage(id)

                    } else {
                        print("ID es null")
                    }
                    
                    if let firstName: NSString = result.valueForKey("first_name") as? NSString {
                        if let lastName: NSString = result.valueForKey("last_name") as? NSString {
                    
                            self.returnFirstName(firstName, lastName: lastName)
                        }
                    }
   
                }
            })
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    //For logout purposes
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.name.text = "Please sign in above!"
        self.picture.image = nil
        self.stindr.hidden = false
        self.tableView.hidden = true
        self.classButton.hidden = true
        print("User logged out...")
    }
    
    
    //# of rows in UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    //Populates UITableView with cells from items array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.item]
        return cell
    }
    
    //When Cell is pressed
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        sendAlert("Alert", message: "Why do you suck so much?") // Fix for later!
    }

    
    //For Cell deletion/editing
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //Swipe to delete functionality
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.reloadData()
        }
    } */
}

