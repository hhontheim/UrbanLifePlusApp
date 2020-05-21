//
//  BluetoothUUID.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import CoreBluetooth


struct BluetoothService {
    static let all: [CBUUID] = [ulpService, blinkService]
    
    static private let ulpService = CBUUID(string: "F278E33F-D8F1-4F4B-8E04-885A5968FA11")
    static let blinkService = CBUUID(string: "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d")

}

struct BluetoothCharacteristic {
    static let ulpName = CBUUID(string: "4FB34DCC-27AB-4D22-AB77-9E3B03489CFC")
}

struct BTUUID {
    static let blinkOn = CBUUID(string: "e94f85c8-7f57-4dbd-b8d3-2b56e107ed60")
    static let blinkSpeed = CBUUID(string: "a8985fda-51aa-4f19-a777-71cf52abba1e")
    static let blinkService = CBUUID(string: "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d")
    
    static let infoService = CBUUID(string: "180a")
    static let infoManufacturer = CBUUID(string: "2a29")
    static let infoName = CBUUID(string: "2a24")
    static let infoSerial = CBUUID(string: "2a25")
}
