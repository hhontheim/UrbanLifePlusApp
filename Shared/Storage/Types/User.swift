//
//  User.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 17.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation

struct User: Codable {
    // Data from Sign In With Apple
    var userId: String
    var givenName: String
    var familyName: String
    var email: String
    var identityToken: Data
    var authorizationCode: Data
    
    // Other
    var pushToken: String

    var name: String {
        get {
            var n: String = givenName
            
            if !familyName.isEmpty {
                n += " "
                n += familyName
            }
            
            return n
        }
//        set {
//            if let newName = PersonNameComponentsFormatter().personNameComponents(from: newValue), let newGivenName = newName.givenName, let newFamilyName = newName.familyName {
//                givenName = newGivenName
//                familyName = newFamilyName
//            }
//        }
    }
    
    init() {
        userId = ""
        givenName = ""
        familyName = ""
        email = ""
        identityToken = Data()
        authorizationCode = Data()
        
        pushToken = ""
    }
}
