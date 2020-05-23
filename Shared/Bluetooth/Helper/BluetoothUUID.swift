//
//  BluetoothUUID.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import CoreBluetooth


struct BluetoothService {
    static let ulpService = CBUUID(string: "F278E33F-D8F1-4F4B-8E04-885A5968FA11")
    static let infoService = CBUUID(string: "180a")
}

struct BluetoothCharacteristic {
    static let ulpUserName = CBUUID(string: "4FB34DCC-27AB-4D22-AB77-9E3B03489CFC")
    static let ulpUserId = CBUUID(string: "2D58B503-FE42-4010-BA8D-3F6A7632FCD5")
    static let ulpUserLED = CBUUID(string: "6067DAB3-D8C0-4D82-A486-C7499176B57A")
    
//    static let infoManufacturer = CBUUID(string: "2a29")
//    static let infoName = CBUUID(string: "2a24")
    static let infoSerial = CBUUID(string: "2a25")
}
