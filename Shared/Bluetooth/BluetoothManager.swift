//
//  BluetoothManager.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import SwiftUI
import CoreBluetooth

let timeInterval = 1.0

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    var storage: Storage?
    
    @Published private(set) var devicesDisconnected: [BluetoothDevice] = []
    @Published private(set) var devicesConnected: [BluetoothDevice] = []
    
    var timer = Timer()
    
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
                startSearching()
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
            let device: BluetoothDevice = BluetoothDevice(peripheral: peripheral, manager: manager, storage: storage)
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
            dConnected[id] = connectedDevice
        }
        
        peripheral.discoverServices([
            BluetoothService.ulpService,
            BluetoothService.infoService
        ])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect: \(peripheral), error: \(String(describing: error))")
        dDisconnected[peripheral.identifier] = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral \(peripheral), error \(String(describing: error))")
        let id: UUID = peripheral.identifier
        
        if let removedDevice = dConnected.removeValue(forKey: id) {
            dDisconnected[id] = removedDevice
        }
    }
    
    @objc func timerExec() {
        if let userWantsPhoneToConnectToPeripherals = storage?.bluetooth.userWantsPhoneToConnectToPeripherals, let userWantsWatchToConnectToPeripherals = storage?.bluetooth.userWantsWatchToConnectToPeripherals {
            #if os(iOS)
            if userWantsPhoneToConnectToPeripherals {
                connectAllDevices()
            } else {
                disconnectAllDevices()
            }
            #elseif os(watchOS)
            if userWantsWatchToConnectToPeripherals {
                connectAllDevices()
            } else {
                disconnectAllDevices()
            }
            #endif
        }
    }
    
    func connectAllDevices() {
        #if os(iOS)
        for (_, device) in dDisconnected {
            device.connect()
        }
        #elseif os(watchOS)
        for (_, device) in dDisconnected.prefix(2) {
            device.connect()
        }
        #endif
    }
    
    func disconnectAllDevices() {
        let actuallyConnectedDevices = manager.retrieveConnectedPeripherals(withServices: [BluetoothService.ulpService, BluetoothService.infoService])
        
        for (_, device) in dConnected {
            if actuallyConnectedDevices.firstIndex(of: device.peripheral) != nil {
                device.disconnect()
            }
        }
    }
    
    func fetchStorageUpdate() {
        for (_, device) in dConnected {
            device.fetchStorageUpdate()
        }
    }
    
    func startSearching() {
        manager.stopScan()
        manager.scanForPeripherals(withServices: [
            BluetoothService.ulpService,
            BluetoothService.infoService
        ], options: nil)
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
