//
//  FriendProfileViewController.swift
//  StudyBuddy
//
//  Created by Lucas Marzocco on 5/1/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController {
    
    var profileName: String!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = profileName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func letsStudy(sender: AnyObject) {
        print("lets study!")
    }
    
    
    @IBAction func rate(sender: AnyObject) {
        
        print("rate")
    }
    
    
    
    @IBAction func groupWith(sender: AnyObject) {
        
        print("group with")
    }
    
    
    
}
