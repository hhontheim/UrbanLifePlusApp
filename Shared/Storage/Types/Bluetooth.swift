//
//  Bluetooth.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 23.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation

struct Bluetooth: Codable {
    var userWantsPhoneToConnectToPeripherals: Bool
    var userWantsWatchToConnectToPeripherals: Bool

    var userWantsLEDOn: Bool
    
    init() {
        userWantsPhoneToConnectToPeripherals = false
        userWantsWatchToConnectToPeripherals = false
        userWantsLEDOn = false
    }
}
