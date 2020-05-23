//
//  BTView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct BTView: View {
    @EnvironmentObject var storage: Storage
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        let bUserWantsToConnectToPeripherals = Binding(
            get: { self.storage.bluetooth.userWantsToConnectToPeripherals },
            set: {
                self.storage.bluetooth.userWantsToConnectToPeripherals = $0
                self.storage.persist()
        }
        )
        let bUserWantsLEDOn = Binding(
            get: { self.storage.bluetooth.userWantsLEDOn },
            set: {
                self.storage.bluetooth.userWantsLEDOn = $0
                self.storage.persist()
        }
        )
        
        return NavigationView {
            VStack {
                Text("bt.greeting")
                Toggle(isOn: bUserWantsToConnectToPeripherals) {
                    Text("userWantsToConnectToPeripherals")
                }
                Toggle(isOn: bUserWantsLEDOn) {
                    Text("userWantsLEDOn")
                }
                List {
                    Section(header: Text("bt.devicesDisconnected")) {
                        ForEach(bluetoothManager.devicesDisconnected) { device in
                            Text("\(device.name)")
                        }
                    }
                    Section(header: Text("bt.devicesConnected")) {
                        ForEach(bluetoothManager.devicesConnected) { device in
                            Text("\(device.name)")
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle("bt.title")
        }
        .tabItem {
            Text("bt.tab")
            Image(systemName: "antenna.radiowaves.left.and.right")
                .imageScale(.large)
        }
    }
}
