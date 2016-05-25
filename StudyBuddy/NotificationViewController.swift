import Foundation


import UIKit

class NotificationViewController: UITableViewController {
    
    var players:[Player] = playersData
    var requests:[Player] = requestData
    
    override func viewDidLoad() {
        tableView.allowsSelection = false
    }
    
    @IBAction func dismissNotification(sender: AnyObject) {
        print("Dismiss bitch!")
    }
    
    @IBAction func pressY(sender: AnyObject) {
        print("Press y!")
    }
    
    @IBAction func pressN(sender: AnyObject) {
        print("Press n!")
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return (players.count + requests.count)
    }
 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            if(indexPath.row < players.count){
                let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)

                let player = players[indexPath.row] as Player
                let string1 = "You have been added to "
                
                if let mainLabel = cell.viewWithTag(100) as? UILabel {
                    mainLabel.text = string1 + player.game!
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath)
               
                let player = requests[indexPath.row - players.count] as Player
                let string1 = " wants to study for "
                
                if let mainLabel = cell.viewWithTag(101) as? UILabel {
                    mainLabel.text = player.name! + string1 + player.game!
                }

                return cell
            }
            
    }
}