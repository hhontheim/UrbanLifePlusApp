//
//  HomeView.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 17.05.20.
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
        
        return List {
            Section(header: VStack(alignment: .leading) {
                Text("home.greeting \(storage.user.givenName)").font(.body)
                    .padding(.bottom, 8)
                Text("home.sec.connect")
            }) {
                Toggle(isOn: bUserWantsWatchToConnectToPeripherals) {
                    Text("home.sec.connect.watch")
                    .padding()
                }
                Toggle(isOn: bUserWantsPhoneToConnectToPeripherals) {
                    Text("home.sec.connect.phone")
                    .padding()
                }
                NavigationLink(destination: PreferencesList().navigationBarTitle("w.prefs.title")) {
                    Text("w.home.prefs.link")
                        .padding()
                }
            }
            Section(header: Text("home.sec.devices")) {
                if bluetoothManager.devicesConnected.isEmpty {
                    Text("home.sec.devices.none")
                        .padding()
                } else {
                    NavigationLink(destination: List {
                        Section(header: Text("w.dev.sec.watch")) {
                            ForEach(bluetoothManager.devicesConnected) { device in
                                Text("\(device.name)")
                            }
                        }
                        .navigationBarTitle("w.dev.title")
                    }) {
                        Text("w.home.dev.link")
                            .padding()
                    }
                }
            }
        }
        .navigationBarTitle("w.home.title")
        .contextMenu(menuItems: {
            Button(action: {
                self.storage.requestDataFromPhone()
            }, label: {
                VStack{
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                    Text("w.home.update")
                }
            })
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
