//
//  FacebookProfile.swift
//  StudyBuddy
//
//  Created by Lucas Marzocco on 5/2/16.
//  Copyright © 2016 Lucas Marzocco. All rights reserved.
//

import UIKit
import Foundation

struct FacebookProfile {
    
    var firstName: String!
    var lastName: String!
    var studyScore: Int!
    var studyTitle: String!
    var currentGroups: [String]
    var currentClasses: [String]
    var profilePic: String!
    var ref: String!
    var id: Int!
    var classBoolean: Bool!
    
    
    init(firstName: String!, lastName: String!, studyScore: Int!, studyTitle: String!, currentGroups: [String], currentClasses: [String], profilePic: String!, ref: String!, id: Int!, classBoolean: Bool!) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.studyScore = studyScore
        self.studyTitle = studyTitle
        self.currentGroups = currentGroups
        self.currentClasses = currentClasses
        self.profilePic = profilePic
        self.ref = ref
        self.id = id
        self.classBoolean = true;
    }
    

    func toAnyObject() -> AnyObject {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "studyScore": studyScore,
            "studyTitle": studyTitle,
            "currentGroups": currentGroups,
            "currentClasses": currentClasses,
            "profilePic": profilePic,
            "ref": ref,
            "id": String(id),
            "classBoolean": classBoolean
        ]
    }
}
