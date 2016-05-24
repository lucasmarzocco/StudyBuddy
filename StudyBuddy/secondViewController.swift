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
    var dbClasses: [String] = []
    var classDictionary: [String:[String]] = ["":[]]
    
    @IBAction func addClass(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Class Name", message: "Ex: CSE100", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(addTextField)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: wordEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setAllUserData(stuff: FDataSnapshot) {
        
        var newClasses: [String] = []
        
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
            newClasses.append(item)
        }
        
        self.items = newClasses
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
            
            var internalClasses: [String] = []
            var students: [String] = []
            var localDict: [String: [String]] = [:]
            
            for stuff in snapshot.children {
                internalClasses.append(stuff.key)
                students = self.setUpClassDictionary(stuff.key, classInfo: stuff as! FDataSnapshot)
                localDict[stuff.key] = students
            }
            
            self.dbClasses = internalClasses
            self.classDictionary = localDict
            
            print("What's in the dictionary?")
            print(self.classDictionary)
            
            }, withCancelBlock: { error in
                print("An error has occurred")
        })
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
    }
    
    func setUpClassDictionary(classString: String!, classInfo: FDataSnapshot) -> [String] {
        
        var students: [String] = []
        
        for student in classInfo.value.objectForKey("currentStudents") as! [String] {
            students.append(student)
        }
        
        return students
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
            
            let classBooleanString = "/" + String(self.passedID) + "/classBoolean"
            let fullClassBooleanString = passedRef + classBooleanString
            let classBooleanURL = Firebase(url: fullClassBooleanString)
            var classString = ""
            
            if(items.count == 1) {
                classString = items[0]
                items[0] = ""
                classBooleanURL.setValue(true)
            }
            else {
                classString = items[indexPath.row]
                items.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }

            let currentClassesString = "/" + String(self.passedID) + "/currentClasses"
            let fullCurrentClassesString = passedRef + currentClassesString
            let currentClassesURL = Firebase(url: fullCurrentClassesString)
            
            let classReference = classRef.childByAppendingPath(classString + "/currentStudents")
            let currentState = self.classDictionary[classString] as [String]!
            
            if(currentState.count == 1) {
                classDictionary[classString] = nil
            }
            else {
                let newStudents = self.removeStudentName(String(self.firstName) + " " + String(self.lastName), className: classString)
                classDictionary[classString] = newStudents
            }
            currentClassesURL.setValue(items)
            classReference.setValue(classDictionary[classString])
            tableView.reloadData()
        }
    }
    
    func removeStudentName(name: String!, className: String!) -> [String] {
        
        var newStudents: [String] = []
        
        for student in classDictionary[className]! {
            if(student != name) {
                newStudents.append(student)
            }
        }
        
        return newStudents
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
        
            let classBooleanString = "/" + String(self.passedID) + "/classBoolean"
            let fullClassBooleanString = passedRef + classBooleanString
            let classBooleanURL = Firebase(url: fullClassBooleanString)
            
            if(self.firstEntry) {
                items[0] = self.wordField!.text!.uppercaseString
                classBooleanURL.setValue(false)
            }
            else {
                items.append(self.wordField!.text!.uppercaseString)
            }

            let currentClassesString = "/" + String(self.passedID) + "/currentClasses"
            let fullCurrentClassesString = passedRef + currentClassesString
            let currentClassesURL = Firebase(url: fullCurrentClassesString)
            currentClassesURL.setValue(items)
            
            
            let classString = self.wordField!.text!.uppercaseString
            let classReference = classRef.childByAppendingPath(classString + "/currentStudents")
            
            if(dbClasses.contains(classString)) {
                
                if(!classDictionary[classString]!.contains(String(self.firstName) + " " + String(self.lastName))) {
                    
                    var studentList = classDictionary[classString] as [String]!
                    studentList.append(String(self.firstName) + " " + String(self.lastName))
                    classDictionary[classString] = studentList
                }
            }
            
            else {
                var newArr: [String] = []
                newArr.append(String(self.firstName) + " " + String(self.lastName))
                classDictionary[classString] = newArr
            }

            classReference.setValue(classDictionary[classString])
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

