//
//  AppState.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 17.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation

struct AppState: Codable {
    var userIsRegistered: Bool
    var userIsLoggedIn: Bool
    var shouldGoToSettingsToRevokeSIWA: Bool
    
    init() {
        userIsRegistered = false
        userIsLoggedIn = false
        shouldGoToSettingsToRevokeSIWA = false
    }
}
