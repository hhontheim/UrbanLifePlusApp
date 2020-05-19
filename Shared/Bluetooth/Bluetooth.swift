//
//  Bluetooth.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import SwiftUI
import CoreBluetooth

class Bluetooth: ObservableObject, BTManagerDelegate {
    @EnvironmentObject var storage: Storage
    
    private var manager = BTManager()
    private var devices: [BTDevice] = []
    
    init() {
        updateStatusLabel()
        manager.delegate = self
    }
    
    func didChangeState(state: CBManagerState) {
        devices = manager.devices
        updateStatusLabel()
    }
    
    func didDiscover(device: BTDevice) {
        devices = manager.devices
    }
    
    func didEnableScan(on: Bool) {
        updateStatusLabel()
    }
    
    func updateStatusLabel() {
        print("state: \(manager.state), scan: \(manager.scanning)")
    }
}
