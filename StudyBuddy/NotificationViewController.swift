

import Foundation


import UIKit

class NotificationViewController: UITableViewController {
    
    var players:[Player] = playersData
    var requests:[Player] = requestData
    
    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
   
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return (players.count + requests.count)
        // return players.count
    }
 
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
           // let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
             //   as! PlayerCell
            //let cell:UITableViewCell?
            if(indexPath.row < players.count){
                let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)

                let player = players[indexPath.row] as Player
                let string1 = "You have been added to "
                
                if let mainLabel = cell.viewWithTag(100) as? UILabel { //3
                    mainLabel.text = string1 + player.game!
                }
            
                //cell.textLabel?.text = string1 + player.game!
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell", forIndexPath: indexPath)
               
                let player = requests[indexPath.row - players.count] as Player
                let string1 = " wants to study for "
                
                if let mainLabel = cell.viewWithTag(101) as? UILabel { //3
                    mainLabel.text = player.name! + string1 + player.game!
                }
                
                //cell.textLabel?.text = player.name! + string1 + player.game!
           

                return cell
                //tableView.deleteRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
            }
            
            
            //let string2 = "[name] wants to study [game] with you"
        
            //return cell!
    }
}