//
//  BluetoothManagerDelegate.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BluetoothManagerDelegate: class {
    func didDiscover(device: BluetoothDevice)
    func didEnableScan(on: Bool)
    func didChangeState(state: CBManagerState)
}
