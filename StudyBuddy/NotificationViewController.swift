import Foundation


import UIKit
import Firebase

class NotificationViewController: UITableViewController {
    
    var items: [String] = []
    var notification: [String] = []
    var passedID: NSString!
    var studentDictionary: [String: String] = [:]
    var otherNotifications: [String] = []
    
    let ref = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    let dictRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Dict")
    var userRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    
    override func viewDidLoad() {
        
        tableView.backgroundColor = UIColor.blackColor()
        
        userRef = ref.childByAppendingPath(passedID as String).childByAppendingPath("notifications")
        
        userRef.observeEventType(.Value, withBlock: { snapshot in
            
            var localItems: [String] = []
            var localNotifications: [String] = []
            
            self.items = []
            self.notification = []
            
            for stuff in snapshot.children {
                print("executing from firebase!!!!")
                let item = self.getValue(stuff as! FDataSnapshot)
                localNotifications.append(item)
                let fullNameArr = item.characters.split{$0 == "/"}.map(String.init)
                let notification = self.displayDataNicely(fullNameArr)
                localItems.append(notification)
            }
            
            self.items = localItems
            self.notification = localNotifications
            self.tableView.reloadData()
        })
        
        dictRef.observeEventType(.Value, withBlock: { snapshot in
            
            var localDict: [String: String] = [:]
            
            for stuff in snapshot.children {
                let id = stuff.key
                let name = self.setUpStudentDictionary(stuff as! FDataSnapshot)
                localDict[id] = name
            }
            
            self.studentDictionary = localDict
        })
    }
    
    func setUpStudentDictionary(snapshot: FDataSnapshot) -> String {
        return snapshot.value as! String
    }
    
    func displayDataNicely(arr: [String]) -> String {
        
        var first = ""
        
        if(arr[0] == "R") {
            first += "STUDY REQUEST: "
        }
        else if(arr[0] == "G") {
            first += "GROUP REQUEST: "
        }
        else {
            first += "REQUEST ACCEPTED: "
        }
        
        let day1 = arr[2]
        let fullDate = day1.characters.split{$0 == "-"}.map(String.init)
        
        let fullTime = arr[1].characters.split{$0 == " "}.map(String.init)
        let fullMinutes = fullTime[0].characters.split{$0 == ":"}.map(String.init)
        
        let ampm = fullTime[1]
        var notificationHour = Int(fullMinutes[0])
        let notificationMinute = Int(fullMinutes[1])
        
        if(ampm == "PM") {
            notificationHour = notificationHour! + 12
        }
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute, .Second], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        
        let date1 = NSCalendar.currentCalendar().dateWithEra(1, year: year, month: month, day: day, hour: hour, minute: minute, second: 0, nanosecond: 0)!
        let date2 = NSCalendar.currentCalendar().dateWithEra(1, year: Int(fullDate[2])!, month: Int(fullDate[0])!, day: Int(fullDate[1])!, hour: notificationHour!, minute: notificationMinute!, second: 0, nanosecond: 0)!
        
        var output = ""
        
        if(daysFrom(date1, toDate: date2) >= 1) {
            output = " in " + String(daysFrom(date1, toDate: date2)) + " days"
        }
        else if(hoursFrom(date1, toDate: date2) >= 1) {
            output = " in " + String(hoursFrom(date1, toDate: date2)) + " hours"
        }
        else if(minutesFrom(date1, toDate: date2) >= 1) {
            output = " in " + String(minutesFrom(date1, toDate: date2)) + " minutes"
        }
        else {
            output = "REQUEST CLOSED"
            return output
        }
        
        first += arr[5]
        first += output
        
        return first
    }
    
    func daysFrom(fromDate:NSDate, toDate: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: fromDate, toDate: toDate, options: []).day
    }
    
    func hoursFrom(fromDate:NSDate, toDate: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: fromDate, toDate: toDate, options: []).hour
    }
    
    func minutesFrom(fromDate:NSDate, toDate: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: fromDate, toDate: toDate, options: []).minute
    }
    
    func getValue(snapshot: FDataSnapshot) -> String {
        return snapshot.value as! String
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = items[indexPath.item]
        cell.textLabel?.textColor = UIColor.orangeColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(items[indexPath.row].containsString("STUDY REQUEST")) {
            
            var notify = notification[indexPath.row].characters.split{$0 == "/"}.map(String.init)
            let request = "You have been requested by " + notify[5] + " to study at " + notify[3] + " on " + notify[2] + " at " + notify[1] + ". Do you accept?"
            
            let alert = UIAlertController(title: "Study Request", message: request, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ACCEPT", style: UIAlertActionStyle.Default, handler: { action in
                
                self.accept(notify)
                notify[0] = "A"
                
                self.items[indexPath.row] = self.displayDataNicely(notify)
                self.notification[indexPath.row] = self.returnAString(notify)
                
                tableView.reloadData()
                
                self.userRef.setValue(self.notification)
                
            }))
            
            alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func returnAString(arr: [String]) -> String {
        
        let output = arr[0] + "/" + arr[1] + "/" + arr[2] + "/"
        let finaloutput = output + arr[3] + "/"
        let finalfinaloutput = finaloutput + arr[4] + "/" + arr[5]
        
        return finalfinaloutput
        
    }
    
    
    func accept(info: [String]) {
        self.sendAlert("Accepted!", message: info[5] + " has been notified!")
        
        let sendRef = self.ref.childByAppendingPath(info[4]).childByAppendingPath("notifications")
        
        sendRef.observeEventType(.Value, withBlock: { snapshot in
            
            var localNotifications: [String] = []
            
            for stuff in snapshot.children {
                
                let data = self.getValue(stuff as! FDataSnapshot)
                localNotifications.append(data)
            }
            
            self.otherNotifications = localNotifications
        })
        
        let new = requestAccepted(info)
        otherNotifications.append(new)
        sendRef.setValue(otherNotifications)
    }
    
    func requestAccepted(info: [String]) -> String {
        
        let requestType = "A"
        let id = passedID as String
        let name = studentDictionary[id]
        
        let output = requestType + "/" + info[1] + "/" + info[2] + "/"
        let finaloutput = output + info[3] + "/"
        let finalfinaloutput = finaloutput + id + "/" + name!
        
        return finalfinaloutput
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.reloadData()
        }
    }
    
    
    //Alert function that shows pop up alerts to the user
    func sendAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}