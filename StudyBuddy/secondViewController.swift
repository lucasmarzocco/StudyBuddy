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


class secondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var welcomeSign: UILabel!
    @IBOutlet weak var studyScore: UIImageView!
    @IBOutlet weak var studyTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var wordField: UITextField?
    @IBOutlet weak var mainPage: UITabBarItem!
    
    var profPic: UIImageView!
    var firstName: NSString!
    var lastName: NSString!
    var scoreInput = 5
    var studyTitleInput = "Study Master"
    
    var items: [String] = ["ECE158B", "COGS185", "ENG100D", "CSE190"]
    
    @IBAction func addClass(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Class Name", message: "Ex: CSE100", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(addTextField)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: wordEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = "\(scoreInput)Stars"
        studyScore.image = UIImage(named:imageName)
        studyTitle.text? = studyTitleInput
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        filterList()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //# of rows in UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
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
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.reloadData()
        }
    }
    
    //Sorts class list
    func filterList() {
        items.sortInPlace() { $0 < $1 }
        tableView.reloadData()
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
    
    @IBAction func done(segue: UIStoryboardSegue) {
    }
}

