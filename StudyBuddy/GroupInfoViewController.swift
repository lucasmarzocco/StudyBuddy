//
//  GroupInfoViewController.swift
//  StudyBuddy
//
//  Created by Lucas Marzocco on 6/6/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit
import Firebase

class GroupInfoViewController: UIViewController {
    
    let groupsRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Groups")
    let userRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    
    @IBOutlet weak var tableView: UITableView!
    
    var members: [String] = []
    var memberName: String = ""
    var groupName: String = ""
    var facebookID: String = ""
    var groups: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.blackColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let groupName = members[indexPath.row]
        cell.textLabel?.text = groupName
        cell.textLabel?.textColor = UIColor.orangeColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func removeName(name: String) -> [String] {
        
        var newMembers: [String] = []
        
        for member in members {
            if(member != name) {
                newMembers.append(member)
            }
        }
        
        return newMembers
    }
    
    func removeGroup(name: String) -> [String] {
        
        print("REMOVING GROUP!!!!!!!!!!!!!!!!")
        var newGroups: [String] = []
        
        print(groups)
        for group in groups {
            print(group + " " + name)
            if(group != name) {
                newGroups.append(group)
            }
        }
        
        return newGroups
    }
    

    @IBAction func leaveGroup(sender: AnyObject) {
        
        
        print("members")
        print(members)
        
        
        members = self.removeName(memberName)
        
        print(members)
        
        let removal = groupsRef.childByAppendingPath(groupName).childByAppendingPath("currentMembers")
        removal.setValue(members)
        
        print("groups you're in now")
        print(groups)
        print(groupName)
        groups = self.removeGroup(groupName)
        
        print("groups you're in after")
        print(groups)
        
        let removal1 = userRef.childByAppendingPath(facebookID).childByAppendingPath("currentGroups")
        removal1.setValue(groups)
        
        tableView.reloadData()
    }
}
