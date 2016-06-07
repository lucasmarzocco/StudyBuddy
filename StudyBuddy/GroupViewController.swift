import UIKit
import Firebase

class GroupViewController: UITableViewController, UIPickerViewDelegate {
    
    let ref = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    var groupRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    let groupsRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Groups")
    let dictRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Dict")
    
    var groups: [String] = []
    var facebookID: NSString!
    var groupName: UITextField?
    var dbGroups: [String] = []
    var studentDictionary: [String:String] = [:]
    var groupDictionary: [String:[String]] = [:]
    var chosenGroup: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.blackColor()
        
        groupRef = ref.childByAppendingPath(facebookID as String).childByAppendingPath("currentGroups")
        
        groupRef.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems: [String] = []
            
            for item in snapshot.children {
                let group = self.retrieveInfo(item as! FDataSnapshot)
                newItems.append(group)
            }
            self.groups = newItems
            print("my groups")
            print(self.groups)
            self.tableView.reloadData()
        })
        
        groupsRef.observeEventType(.Value, withBlock: { snapshot in
            
            var internalGroups: [String] = []
            var members: [String] = []
            var localDict: [String: [String]] = [:]
            
            for stuff in snapshot.children {
                internalGroups.append(stuff.key)
                members = self.setUpGroupDictionary(stuff.key, classInfo: stuff as! FDataSnapshot)
                localDict[stuff.key] = members
            }
            
            self.dbGroups = internalGroups
            print("groups on database")
            print(self.dbGroups)
            self.groupDictionary = localDict
            print("group dict")
            print(self.groupDictionary)
            self.tableView.reloadData()

        })
        
        dictRef.observeEventType(.Value, withBlock: { snapshot in
            
            var localDict: [String: String] = [:]
            
            for stuff in snapshot.children {
                let id = stuff.key
                let name = self.retrieveInfo(stuff as! FDataSnapshot)
                localDict[id] = name
            }
            
            self.studentDictionary = localDict
            print("student dict")
            print(self.studentDictionary)
        })
    }
    
    func setUpGroupDictionary(classString: String!, classInfo: FDataSnapshot) -> [String] {
        
        var members: [String] = []
        
        for student in classInfo.value.objectForKey("currentMembers") as! [String] {
            members.append(student)
        }
        
        return members
    }
    
    func retrieveInfo(stuff: FDataSnapshot) -> String {
        
        return stuff.value as! String
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let groupName = groups[indexPath.row]
        cell.textLabel?.textColor = UIColor.orangeColor()
        cell.textLabel?.text = groupName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        chosenGroup = groups[indexPath.row]
        self.performSegueWithIdentifier("goToGroupProfile", sender: self)
    }
    
    @IBAction func addGroup(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Add Group", message: "Enter the group name and class", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler ({ (textField: UITextField!) in
            textField.placeholder = "STNDR"
            self.groupName = textField })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: groupEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func groupEntered(alert: UIAlertAction!) {
        
        if(self.groupName?.text?.uppercaseString == "") {
            self.sendAlert("ERROR", message: "Fields can't be empty!")
        }
        else if groups.contains((self.groupName?.text?.uppercaseString)!) {
            sendAlert("Duplicate Entry", message: "Group already has been added!")
        }
        
        else {
            let groupString = self.groupName!.text!.uppercaseString
            groups.append(groupString)
            groupRef.setValue(groups)
            
            if(dbGroups.contains(groupString)) {
                
                if(!groupDictionary[groupString]!.contains(studentDictionary[facebookID as String]!)) {
                    
                    var studentList = groupDictionary[groupString] as [String]!
                    studentList.append(studentDictionary[facebookID as String]!)
                    groupDictionary[groupString] = studentList
                }
            }
                
            else {
                
                var newArr: [String] = []
                newArr.append(studentDictionary[facebookID as String]!)
                groupDictionary[groupString] = newArr
            }
            
            let membersList = groupsRef.childByAppendingPath(groupString).childByAppendingPath("currentMembers")
            membersList.setValue(groupDictionary[groupString])

        }
    }
    
    
    //Alert function that shows pop up alerts to the user
    func sendAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToGroupProfile") {
            let dest = segue.destinationViewController as! GroupInfoViewController
            dest.members = groupDictionary[chosenGroup]!
            dest.facebookID = facebookID as String
            dest.groups = self.groups
            dest.groupName = chosenGroup
            dest.memberName = studentDictionary[facebookID as String]!
        }
    }
}
