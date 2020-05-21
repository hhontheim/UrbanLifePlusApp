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

let timeInterval = 1.0

class Bluetooth: NSObject, ObservableObject, CBCentralManagerDelegate {
    @EnvironmentObject var storage: Storage
    
    @Published private(set) var devicesDisconnected: [BluetoothDevice] = []
    @Published private(set) var devicesConnected: [BluetoothDevice] = []

    
    var timer = Timer()
    
    @Published var userWantsToConnect: Bool = false { // TODO: Read from storage
        didSet {
            // foo() // TODO: Do this
        }
    }
    
    private let manager: CBCentralManager
    
    private var dConnected: [UUID:BluetoothDevice] = [:] {
        didSet {
            devicesConnected = Array(dConnected.values)
        }
    }
    private var dDisconnected: [UUID:BluetoothDevice] = [:] {
        didSet {
            devicesDisconnected = Array(dDisconnected.values)
        }
    }
    
    private var isActive: Bool = false {
        didSet {
            if (oldValue == isActive) {
                return
            }
            print("scanning: \(isActive)")
            if (isActive) {
                manager.scanForPeripherals(withServices: BluetoothService.all, options: nil)
            } else {
                manager.stopScan()
            }
            didEnableScan(on: isActive)
        }
    }
    
    override init() {
        manager = CBCentralManager(delegate: nil, queue: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: true,
            CBCentralManagerOptionShowPowerAlertKey: true
        ])
        super.init()
        manager.delegate = self
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerExec), userInfo: nil, repeats: true)
        printStateAndScanning()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("state \(central.state)")
        
        switch manager.state {
        case .unknown,.resetting:
            break
        case .poweredOn:
            isActive = true
        default:
            isActive = false
            dDisconnected = [:]
            dConnected = [:]
        }
        
        didChangeState(state: manager.state)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let id: UUID = peripheral.identifier
        
        if dConnected[id] != nil {
            print("already connected to newly discovered peripheral: \(peripheral)")
        } else if dDisconnected[id] == nil {
            print("new peripheral in range: \(peripheral), rssi: \(RSSI)")
            let device: BluetoothDevice = BluetoothDevice(peripheral: peripheral, manager: manager)
            dDisconnected[id] = device
            didDiscover(device: device, rssi: RSSI)
        } else {
            print("seen again peripheral: \(peripheral)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected \(peripheral)")
        let id: UUID = peripheral.identifier
        
        if let connectedDevice = dDisconnected.removeValue(forKey: id) {
            //dDisconnected[id] = nil // TODO: Needed?
            dConnected[id] = connectedDevice
        }
        
        peripheral.discoverServices([BTUUID.blinkService, BTUUID.infoService])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect: \(peripheral), error: \(String(describing: error))")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral \(peripheral), error \(String(describing: error))")
        let id: UUID = peripheral.identifier
        
        if let removedDevice = dConnected.removeValue(forKey: id) {
            dDisconnected[id] = removedDevice
        }
    }
    
    @objc func timerExec() {
        if userWantsToConnect {
            connectAllDevices()
        } else {
            disconnectAllDevices()
        }
    }
    
    func connectAllDevices() {
        for (_, device) in dDisconnected {
            device.connect()
        }
    }
    
    func disconnectAllDevices() {
        for (_, device) in dConnected {
            device.disconnect()
        }
    }
    
    // MARK: - Additional methods to react to changes. Just used for printings for now.
    
    func didChangeState(state: CBManagerState) {
//        print("didChangeState: \(state)")
//        printStateAndScanning()
    }
    
    func didDiscover(device: BluetoothDevice, rssi: NSNumber) {
//        print("didDiscover: \(device)")
    }
    
    func didEnableScan(on: Bool) {
//        print("didEnableScan: \(on)")
//        printStateAndScanning()
    }
    
    func printStateAndScanning() {
//        print("state: \(manager.state), scan: \(isActive)")
    }
}
