//
//  BluetoothDevice.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothDevice: NSObject, CBPeripheralDelegate {
    private let peripheral: CBPeripheral
    private let manager: CBCentralManager
    private var blinkChar: CBCharacteristic?
    private var speedChar: CBCharacteristic?
    private var _blink: Bool = false
    private var _speed: Int = 5
    
    weak var delegate: BluetoothDeviceDelegate?
    var blink: Bool {
        get {
            return _blink
        }
        set {
            guard _blink != newValue else { return }
            
            _blink = newValue
            if let char = blinkChar {
                peripheral.writeValue(Data(bytes: [_blink ? 1 : 0]), for: char, type: .withResponse)
            }
        }
    }
    var speed: Int {
        get {
            return _speed
        }
        set {
            guard _speed != newValue else { return }
            
            _speed = newValue
            if let char = speedChar {
                peripheral.writeValue(Data(bytes: [UInt8(_speed)]), for: char, type: .withResponse)
            }
        }
    }
    var name: String {
        return peripheral.name ?? "Unknown device"
    }
    var detail: String {
        return peripheral.identifier.description
    }
    private(set) var serial: String?
    
    init(peripheral: CBPeripheral, manager: CBCentralManager) {
        self.peripheral = peripheral
        self.manager = manager
        super.init()
        self.peripheral.delegate = self
    }
    
    func connect() {
        manager.connect(peripheral, options: nil)
    }
    
    func disconnect() {
        manager.cancelPeripheralConnection(peripheral)
    }
    
    // MARK: - these are called from BluetoothManager, do not call directly
    
    func connectedCallback() {
        peripheral.discoverServices([BTUUID.blinkService, BTUUID.infoService])
        delegate?.deviceConnected()
    }
    
    func disconnectedCallback() {
        delegate?.deviceDisconnected()
    }
    
    func errorCallback(error: Error?) {
        print("Device: error \(String(describing: error))")
    }
    
    // MARK: - Delegate implementation
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Device: discovered services")
        peripheral.services?.forEach {
            print("  \($0)")
            if $0.uuid == BTUUID.infoService {
                peripheral.discoverCharacteristics([BTUUID.infoSerial], for: $0)
            } else if $0.uuid == BTUUID.blinkService {
                peripheral.discoverCharacteristics([BTUUID.blinkOn,BTUUID.blinkSpeed], for: $0)
            } else {
                peripheral.discoverCharacteristics(nil, for: $0)
            }
            
        }
        print()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Device: discovered characteristics")
        service.characteristics?.forEach {
            print("   \($0)")
            
            if $0.uuid == BTUUID.blinkOn {
                self.blinkChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUID.blinkSpeed {
                self.speedChar = $0
                peripheral.readValue(for: $0)
            } else if $0.uuid == BTUUID.infoSerial {
                peripheral.readValue(for: $0)
            }
        }
        print()
        
        delegate?.deviceReady()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Device: updated value for \(characteristic)")
        
        if characteristic.uuid == blinkChar?.uuid, let b = characteristic.value?.parseBool() {
            _blink = b
            delegate?.deviceBlinkChanged(value: b)
        }
        if characteristic.uuid == speedChar?.uuid, let s = characteristic.value?.parseInt() {
            _speed = Int(s)
            delegate?.deviceSpeedChanged(value: _speed)
        }
        if characteristic.uuid == BTUUID.infoSerial, let d = characteristic.value {
            serial = String(data: d, encoding: .utf8)
            if let serial = serial {
                delegate?.deviceSerialChanged(value: serial)
            }
        }
    }
}


