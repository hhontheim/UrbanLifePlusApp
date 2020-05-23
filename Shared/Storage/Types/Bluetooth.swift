//
//  Bluetooth.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 23.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation

struct Bluetooth: Codable {
    var userWantsToConnectToPeripherals: Bool
    
    var userWantsLEDOn: Bool
    
    init() {
        userWantsToConnectToPeripherals = false
        userWantsLEDOn = false
    }
}
