//
//  BluetoothManager.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private let manager: CBCentralManager
    private var seenDevices: [UUID:BluetoothDevice] = [:]
    var devices: [BluetoothDevice] {
        return Array(seenDevices.values)
    }
    var state: CBManagerState {
        return manager.state
    }
    weak var delegate: BluetoothManagerDelegate?
    
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
            delegate?.didEnableScan(on: scanning)
        }
    }
    
    
    override init() {
        manager = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        super.init()
        manager.delegate = self
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
        
        delegate?.didChangeState(state: manager.state)
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
            delegate?.didDiscover(device: device)
        } else {
            print("Manager: seen again \(peripheral)")
        }
    }
    
    
}
