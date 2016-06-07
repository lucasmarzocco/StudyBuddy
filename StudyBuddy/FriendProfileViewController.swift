//
//  FriendProfileViewController.swift
//  StudyBuddy
//
//  Created by Lucas Marzocco on 5/1/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit
import Firebase

class FriendProfileViewController: UIViewController {
    
    let ref = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    var profPicRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    var studyScoreRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    var numberRatings = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    var notRef = Firebase(url: "https://incandescent-heat-2456.firebaseio.com/Users")
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var studyScore: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var backgroundPic: UIImageView!
    
    var wordField1: UITextField?
    var wordField2: UITextField?
    var wordField3: UITextField?
    var profileName: String!
    var profileID: String!
    var score: Int!
    var numberOfRatings: Int!
    var boolean: DarwinBoolean!
    var notifications: [String] = []
    var studentDictionary: [String:String] = [:]
    var userID: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            backgroundPic.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = backgroundPic.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            self.view.addSubview(studyScore)
            self.view.addSubview(ratingCount)
        }
        else {
            backgroundPic.backgroundColor = UIColor.blackColor()
        }
        
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
        self.view.bringSubviewToFront(profilePicture)
 
        boolean = true
        label.text = profileName
        profPicRef = ref.childByAppendingPath(profileID).childByAppendingPath("profilePic")
        studyScoreRef = ref.childByAppendingPath(profileID).childByAppendingPath("studyScore")
        numberRatings = ref.childByAppendingPath(profileID).childByAppendingPath("numberRatings")
        notRef = ref.childByAppendingPath(profileID).childByAppendingPath("notifications")
        
        profPicRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let url = NSURL(string: snapshot.value as! String)
            let data = NSData(contentsOfURL: url!)
            self.profilePicture.image = UIImage(data:data!)
            self.backgroundPic.image = UIImage(data:data!)
        })
        
        numberRatings.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.numberOfRatings = snapshot.value as! Int
            self.ratingCount.text = "# of ratings:  \(self.numberOfRatings)"
        })
        
        studyScoreRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var score = 0
            
            if(self.numberOfRatings == 0) {
                score = 0
            }
            else {
                score = ((snapshot.value as! Int) / self.numberOfRatings)
            }

            let url = "\(score)Stars"
            self.score = snapshot.value as! Int
            self.studyScore.image = UIImage(named:url)
        })
        
        notRef.observeEventType(.Value, withBlock: { snapshot in
            
            var localItems: [String] = []
            
            for stuff in snapshot.children {
                
                let item = self.getValue(stuff as! FDataSnapshot)
                print("ON friend profile view controller (From FIREBASE): " + item)
                localItems.append(item)
            }
            
            self.notifications = localItems
        })
        
    }
    
    func getValue(snapshot: FDataSnapshot) -> String {
        return snapshot.value as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func letsStudy(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Propose a study time", message: "Enter a time, date, and place", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler ({ (textField: UITextField!) in
            textField.placeholder = "Ex: 2:00 PM"
            self.wordField1 = textField })
        
        alert.addTextFieldWithConfigurationHandler ({ (textField: UITextField!) in
            textField.placeholder = "Ex: 10-2-2016"
            self.wordField2 = textField })
        
        alert.addTextFieldWithConfigurationHandler ({ (textField: UITextField!) in
            textField.placeholder = "Ex: Price Center"
            self.wordField3 = textField })
        
        alert.addAction(UIAlertAction(title: "Study!", style: UIAlertActionStyle.Default, handler: wordEntered))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func rate(sender: AnyObject) {
        
        if(!self.boolean) {
            self.sendAlert("ERROR", message: "You have already rated " + profileName + "!")
        }
        else {
            self.boolean = false;
            let alert = UIAlertController(title: "Rate", message: "Please rate " + profileName, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "1 Star", style: UIAlertActionStyle.Default, handler: rating))
            alert.addAction(UIAlertAction(title: "2 Stars", style: UIAlertActionStyle.Default, handler: rating))
            alert.addAction(UIAlertAction(title: "3 Stars", style: UIAlertActionStyle.Default, handler: rating))
            alert.addAction(UIAlertAction(title: "4 Stars", style: UIAlertActionStyle.Default, handler: rating))
            alert.addAction(UIAlertAction(title: "5 Stars", style: UIAlertActionStyle.Default, handler: rating))
            self.presentViewController(alert, animated: true, completion: nil)
        
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.sendAlert("Confirmation", message: "Your rating for " + self.profileName + " has been received!")
            }
        }
    }
    
    //Add new class to the list
    func wordEntered(alert: UIAlertAction!) {
        
        let notification = "R/" + self.wordField1!.text! + "/" + self.wordField2!.text! + "/"
        let notification1 = notification + self.wordField3!.text! + "/"
        let notification2 = notification1 + self.userID + "/" + self.studentDictionary[self.userID]!
        
        print("BEFORE: ")
        print(self.notifications)
        
        self.notifications.append(notification2)
        
        print("AFTER: ")
        
        print(self.notifications)
        
        notRef.setValue(self.notifications)
    }
    
    func rating(alert: UIAlertAction!) {
        updateStudyScore(alert.title!)
    }
    
    func updateStudyScore(currentScore: String) {
        
        numberOfRatings = numberOfRatings + 1
        let newRating: Int! = Int("\(currentScore[currentScore.startIndex])") as Int!
        let totalScore = newRating + score
        
        studyScoreRef.setValue(totalScore)
        numberRatings.setValue(numberOfRatings)
    }
    
    //Alert function that shows pop up alerts to the user
    func sendAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
