//
//  BluetoothDevice.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothDevice: NSObject, CBPeripheralDelegate, Identifiable {
    private let storage: Storage?
    private let peripheral: CBPeripheral
    private let manager: CBCentralManager
    private var userNameCharacteristic: CBCharacteristic?
    private var userIdCharacteristic: CBCharacteristic?
    private var userLEDCharacteristic: CBCharacteristic?

    var userName: String = "" {
//        willSet {
//            guard userName != newValue else { return }
//        }
        didSet {
            guard userName != oldValue else { return }
            pushValuesToPeripheral()
        }
    }
    var userId: String = "" {
//        willSet {
//            guard userId != newValue else { return }
//        }
        didSet {
            guard userId != oldValue else { return }
            pushValuesToPeripheral()
        }
    }
    var userLED: Bool = false {
//        willSet {
//            guard userLED != newValue else { return }
//        }
        didSet {
            guard userLED != oldValue else { return }
            pushValuesToPeripheral()
        }
    }
    
    var name: String {
        return peripheral.name ?? "Unknown device"
    }
    var detail: String {
        return peripheral.identifier.description
    }
    private(set) var serial: String?
    
    init(peripheral: CBPeripheral, manager: CBCentralManager, storage: Storage?) {
        self.peripheral = peripheral
        self.manager = manager
        self.storage = storage
        super.init()
        self.peripheral.delegate = self
        fetchStorageUpdate()
    }
    
    func connect() {
        manager.connect(peripheral, options: nil)
        fetchStorageUpdate()
        pushValuesToPeripheral()
    }
    
    func disconnect() {
        manager.cancelPeripheralConnection(peripheral)
    }
    
    func fetchStorageUpdate() {
        guard storage != nil else { return }
        if storage?.appState.userIsLoggedIn ?? false {
            userName = storage!.user.givenName
            userId = storage!.user.userId
            userLED = storage!.bluetooth.userWantsLEDOn
        } else {
            manager.cancelPeripheralConnection(peripheral)
        }
        pushValuesToPeripheral()
    }
    
    func pushValuesToPeripheral() {
        if let characteristic = userNameCharacteristic, let data = userName.data(using: .utf8) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
        if let characteristic = userIdCharacteristic, let data = userId.data(using: .utf8) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
        if let characteristic = userLEDCharacteristic {
            peripheral.writeValue(Data([userLED ? 1 : 0]), for: characteristic, type: .withResponse)
        }
    }
    
    // MARK: - Delegate implementation
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach {
            if $0.uuid == BluetoothService.infoService {
                peripheral.discoverCharacteristics([
//                    BluetoothCharacteristic.infoManufacturer,
//                    BluetoothCharacteristic.infoName,
                    BluetoothCharacteristic.infoSerial
                ], for: $0)
            } else if $0.uuid == BluetoothService.ulpService {
                peripheral.discoverCharacteristics([
                    BluetoothCharacteristic.ulpUserName,
                    BluetoothCharacteristic.ulpUserId,
                    BluetoothCharacteristic.ulpUserLED
                ], for: $0)
            } else {
                peripheral.discoverCharacteristics(nil, for: $0)
            }
        }
        pushValuesToPeripheral()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach {
            if $0.uuid == BluetoothCharacteristic.ulpUserName {
                self.userNameCharacteristic = $0
                peripheral.readValue(for: $0)
            } else if $0.uuid == BluetoothCharacteristic.ulpUserId {
                self.userIdCharacteristic = $0
                peripheral.readValue(for: $0)
            } else if $0.uuid == BluetoothCharacteristic.ulpUserLED {
                self.userLEDCharacteristic = $0
                peripheral.readValue(for: $0)
            } else if $0.uuid == BluetoothCharacteristic.infoSerial {
                peripheral.readValue(for: $0)
            }
        }
        pushValuesToPeripheral()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == BluetoothCharacteristic.infoSerial, let d = characteristic.value {
            serial = String(data: d, encoding: .utf8)
        }
    }
}
