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
    
    init() {
        userId = ""
        givenName = ""
        familyName = ""
        email = ""
        identityToken = Data()
        authorizationCode = Data()
    }
}
