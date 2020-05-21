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
        NavigationView {
            VStack {
                Text("bt.greeting")
                Toggle(isOn: $bluetoothManager.userWantsToConnect) {
                    Text("userWantsToConnect")
                }
                List {
                    Section(header: Text("bt.devicesDisconnected")) {
                        ForEach(bluetoothManager.devicesDisconnected) { device in
                            NavigationLink(destination: BTDeviceView(device: device)) {
                                Text("\(device.name)")
                            }
                        }
                    }
                    Section(header: Text("bt.devicesConnected")) {
                        ForEach(bluetoothManager.devicesConnected) { device in
                            NavigationLink(destination: BTDeviceView(device: device)) {
                                Text("\(device.name)")
                            }
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
