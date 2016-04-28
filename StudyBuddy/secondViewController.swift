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


class secondViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var welcomeSign: UILabel!
    @IBOutlet weak var studyScore: UIImageView!
    @IBOutlet weak var studyTitle: UILabel!
    
    var profPic: UIImageView!
    var firstName: NSString!
    var lastName: NSString!
    var scoreInput = 5
    var studyTitleInput = "Study Master"
    
    @IBOutlet weak var mainPage: UITabBarItem!
    
    @IBAction func logout(sender: AnyObject) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checkStudyScore(firstName)
        
        //profilePicture.image = profPic.image
        let imageName = "\(scoreInput)Stars"
        studyScore.image = UIImage(named:imageName)
        //welcomeSign.text? = "Welcome \(firstName) \(lastName)!"
        studyTitle.text? = studyTitleInput
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func checkStudyScore(name: NSString) {
        
        if(name.isEqualToString("Lucas")) {
            scoreInput = 5
            studyTitleInput = "Study Master"
        }
    }
    


}

