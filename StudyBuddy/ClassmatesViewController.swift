//
//  ClassmatesViewController.swift
//  StudyBuddy
//
//  Created by Lucas Marzocco on 5/1/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit

class ClassmatesViewController: UITableViewController {
    
    var friends: [String] = []
    var facebookID: NSString = ""
    var studentDictionary: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //# of rows in UITableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    //Populates UITableView with cells from items array
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = friends[indexPath.item]
        return cell
    }
    
    //When Cell is pressed
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func findFriendTapped(name: NSString) -> String {
        
        for student in self.studentDictionary.keys {
            if(self.studentDictionary[student] == name) {
                return student
            }
        }
        return ""
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "friendProfile") {
            let vc: FriendProfileViewController = segue.destinationViewController as! FriendProfileViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            vc.profileName = self.friends[selectedRow]
            vc.profileID = self.findFriendTapped(vc.profileName)
        }
    }
}
