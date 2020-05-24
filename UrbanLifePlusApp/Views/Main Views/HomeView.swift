//
//  HomeView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 11.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var storage: Storage
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        let bUserWantsPhoneToConnectToPeripherals = Binding(
            get: { self.storage.bluetooth.userWantsPhoneToConnectToPeripherals },
            set: { self.storage.bluetooth.userWantsPhoneToConnectToPeripherals = $0; self.storage.persist() }
        )
        let bUserWantsWatchToConnectToPeripherals = Binding(
            get: { self.storage.bluetooth.userWantsWatchToConnectToPeripherals },
            set: { self.storage.bluetooth.userWantsWatchToConnectToPeripherals = $0; self.storage.persist() }
        )
        
        return NavigationView {
            List {
                Section(header:
                    HStack {
                        Spacer()
                        Text("home.greeting \(storage.user.givenName)")
                            .font(.title)
                            .padding(.top, 18)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                ) { EmptyView() }
                Section(header: Text("home.sec.connect")) {
                    Toggle(isOn: bUserWantsPhoneToConnectToPeripherals) {
                        Text("home.sec.connect.phone")
                    }
                    Toggle(isOn: bUserWantsWatchToConnectToPeripherals) {
                        Text("home.sec.connect.watch")
                    }
                }
                Section(header: Text("home.sec.devices")) {
                    if bluetoothManager.devicesConnected.isEmpty {
                        Text("home.sec.devices.none")
                    } else {
                        ForEach(bluetoothManager.devicesConnected) { device in
                            Text("\(device.name)")
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(storage.user.givenName.suffix(1) == "s" ? "home.title.name.with.s \(storage.user.givenName)" : "home.title.name.without.s \(storage.user.givenName)")
        }
        .tabItem {
            Text("home.tab")
            Image(systemName: "house.fill")
                .imageScale(.large)
        }
    }
}
