//
//  secondViewController.swift
//  StudyBuddy
//
//  Created by Lucas Marzocco on 4/26/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase


class secondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let ref = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    let classRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Classes")
    let mainRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com")
    
    @IBOutlet weak var welcomeSign: UILabel!
    @IBOutlet weak var studyScore: UIImageView!
    @IBOutlet weak var studyTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var wordField: UITextField?
    @IBOutlet weak var mainPage: UITabBarItem!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var profPic: UIImageView!
    var firstName: NSString!
    var lastName: NSString!
    var passedRef: String!
    var passedID: NSString!
    var firstEntry = true
    var items: [String] = [""]
    var classes: [String] = []
    
    @IBAction func addClass(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Class Name", message: "Ex: CSE100", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(addTextField)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: wordEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setAllUserData(stuff: FDataSnapshot) {
        
        var newItems: [String] = []
        
        //First class added or not
        self.firstEntry = stuff.value.objectForKey("classBoolean") as! Bool
        
        //First name
        self.firstName = stuff.value.objectForKey("firstName") as! String
        
        //Last name
        self.lastName = stuff.value.objectForKey("lastName") as! String
        
        //Reference to firebase
        self.passedRef = stuff.value.objectForKey("ref") as! String
        
        //Welcome sign for profile
        self.welcomeSign.text = "\(self.firstName) \(self.lastName)"
        
        //Study score and pic
        let scoreInput = stuff.value.objectForKey("studyScore") as! Int
        let imageName = "\(scoreInput)Stars"
        self.studyScore.image = UIImage(named:imageName)
        
        //Study title
        let studyTitleInput = stuff.value.objectForKey("studyTitle")
        self.studyTitle.text? = studyTitleInput as! String
        
        //profile pic
        let profilePicName = stuff.value.objectForKey("profilePic") as! String
        let profileURL = NSURL(string:profilePicName)
        let data = NSData(contentsOfURL: profileURL!)
        self.profilePicture.image = UIImage(data: data!)
        
        //classes
        for item in stuff.value.objectForKey("currentClasses") as! [String] {
            newItems.append(item)
        }
        
        self.items = newItems
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            for stuff in snapshot.children {
                
                let id = stuff.value.objectForKey("id") as! NSString
                
                if(id == self.passedID) {
                    
                    self.setAllUserData(stuff as! FDataSnapshot)
                }
            }
            
            }, withCancelBlock: { error in
                print("An error has occurred")
        })
        
        classRef.observeEventType(.Value, withBlock: { snapshot in
            
            print("Classes list is changing!") //check this for changing class list!!!!!!!!!!!!
            
            }, withCancelBlock: { error in
                print("An error has occurred")
        })
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //# of rows in UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(items[0] == "") {
            return 0
        }
        else {
            return items.count
        }
    }
    
    //Populates UITableView with cells from items array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = items[indexPath.item]
        return cell
    }
    
    //When Cell is pressed
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("goToFriends", sender: self)
    }
    
    
    //For Cell deletion/editing
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //Swipe to delete functionality
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let newString = "/" + (self.firstName as String) + " " + (self.lastName as String) + "/classBoolean"
            let new = passedRef + newString
            var changeClass = Firebase(url: new)
            
            if(items.count == 1) {
                items[0] = ""
                changeClass.setValue(true)
            }
            else {
                items.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }

            let newString1 = "/" + (self.firstName as String) + " " + (self.lastName as String) + "/currentClasses"
            let new1 = passedRef + newString1
            changeClass = Firebase(url: new1)
            changeClass.setValue(items)
            tableView.reloadData()
        }
    }
    
    
    //Alert function that shows pop up alerts to the user
     func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
     }
    
    //Add new class to the list
    func wordEntered(alert: UIAlertAction!) {
        
        //Adds the string in uppercase format, no matter what user inputs
        if wordField!.text == "" {
            sendAlert("ERROR", message: "Class field can't be empty!")
        }
        else if items.contains(self.wordField!.text!.uppercaseString) {
            sendAlert("Duplicate Entry", message: "Class already has been added!")
        }
        else if wordField!.text!.containsString(" ") || wordField!.text!.containsString("-") {
            sendAlert("ERROR", message: "Class field cannot have a dash or space!")
        }
        else {
            
            let newString = "/" + (self.firstName as String) + " " + (self.lastName as String) + "/classBoolean"
            let new = passedRef + newString
            let changeClass = Firebase(url: new)
            
            if(self.firstEntry) {
                items[0] = self.wordField!.text!.uppercaseString
                changeClass.setValue(false)
            }
            else {
                items.append(self.wordField!.text!.uppercaseString)
            }

            let newString1 = "/" + (self.firstName as String) + " " + (self.lastName as String) + "/currentClasses"
            let new1 = passedRef + newString1
            let changeClass1 = Firebase(url: new1)
            changeClass1.setValue(items)
            classes.append(self.wordField!.text!.uppercaseString)
            classRef.setValue(classes)
            tableView.reloadData()
        }
    }
    
    //Text field for adding classes
    func addTextField(textField: UITextField!) {
        self.wordField = textField
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
    }
}

