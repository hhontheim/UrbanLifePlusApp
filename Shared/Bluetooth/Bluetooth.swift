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

class Bluetooth: ObservableObject, BluetoothManagerDelegate {
    @EnvironmentObject var storage: Storage
    
    private var manager = BluetoothManager()
    private var devices: [BluetoothDevice] = []
    
    init() {
        updateStatusLabel()
        manager.delegate = self
    }
    
    func didChangeState(state: CBManagerState) {
        devices = manager.devices
        updateStatusLabel()
    }
    
    func didDiscover(device: BluetoothDevice) {
        devices = manager.devices
    }
    
    func didEnableScan(on: Bool) {
        updateStatusLabel()
    }
    
    func updateStatusLabel() {
        print("state: \(manager.state), scan: \(manager.scanning)")
    }
}
