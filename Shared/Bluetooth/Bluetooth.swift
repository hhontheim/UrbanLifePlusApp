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

class Bluetooth: NSObject, ObservableObject, CBCentralManagerDelegate {
    @EnvironmentObject var storage: Storage
    
    private let manager: CBCentralManager
    private var seenDevices: [UUID:BluetoothDevice] = [:]
    var devices: [BluetoothDevice] {
        return Array(seenDevices.values)
    }
    var state: CBManagerState {
        return manager.state
    }
    var scanning: Bool = false {
        didSet {
            if (oldValue == scanning) {
                return
            }
            print("Manager: scan state set to \(scanning)")
            if (scanning) {
                manager.scanForPeripherals(withServices: [BTUUID.blinkService], options: nil)
            } else {
                manager.stopScan()
            }
            didEnableScan(on: scanning)
        }
    }
    
    override init() {
        manager = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        super.init()
        manager.delegate = self
        updateStatusLabel()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Manager: state \(manager.state)")
        
        switch manager.state {
        case .unknown,.resetting:
            break
        case .poweredOn:
            scanning = true
        default:
            scanning = false
            seenDevices = [:]
        }
        
        didChangeState(state: manager.state)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Manager: connected \(peripheral)")
        seenDevices[peripheral.identifier]?.connectedCallback()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Manager: failed connect \(peripheral), error \(String(describing: error))")
        seenDevices[peripheral.identifier]?.errorCallback(error: error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Manager: disconnected \(peripheral), error \(String(describing: error))")
        seenDevices[peripheral.identifier]?.disconnectedCallback()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if seenDevices[peripheral.identifier] == nil {
            print("Manager: discovered \(peripheral), rssi: \(RSSI)")
            let device = BluetoothDevice(peripheral: peripheral, manager: manager)
            seenDevices[peripheral.identifier] = device
            didDiscover(device: device, rssi: RSSI)
        } else {
            print("Manager: seen again \(peripheral)")
        }
    }
    
    func didChangeState(state: CBManagerState) {
        print("didChangeState: \(state)")
        updateStatusLabel()
    }
    
    func didDiscover(device: BluetoothDevice, rssi: NSNumber) {
        print("didDiscover: \(device)")
        device.connect()
    }
    
    func didEnableScan(on: Bool) {
        print("didEnableScan: \(on)")
        updateStatusLabel()
    }
    
    func updateStatusLabel() {
        print("state: \(state), scan: \(scanning)")
    }
}
