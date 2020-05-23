//
//  HomeView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 11.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI
import CustomerlySDK
import Instabug

struct HomeView: View {
    @EnvironmentObject var storage: Storage
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    @State var showHelpSheet: Bool = false
    
    var body: some View {
        let bUserWantsToConnectToPeripherals = Binding(
            get: { self.storage.bluetooth.userWantsToConnectToPeripherals },
            set: {
                self.storage.bluetooth.userWantsToConnectToPeripherals = $0
                self.storage.persist()
        }
        )
        
        return NavigationView {
            List {
                Section {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Image(systemName: "person.crop.square.fill") // profiltImage
                                .resizable()
                                .frame(width: 50, height: 50) // 60 x 60
                                .aspectRatio(contentMode: .fill)
                                //                                .clipShape(Circle())
                                .padding(.vertical, 2)
                            VStack(alignment: .leading) {
                                Text("\(storage.user.givenName) \(storage.user.familyName)")
                                    .font(.headline)
                                Text(storage.user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                Section(header: Text("ble")) {
                    Toggle(isOn: bUserWantsToConnectToPeripherals) {
                        Text("i want to connect to devices")
                    }
                    NavigationLink(destination: BTSettings()) {
                        Text("my preferences")
                    }
                }
                Section(header: Text("devicesConnected")) {
                    if bluetoothManager.devicesConnected.isEmpty {
                        Text("no devices connected")
                    } else {
                        NavigationLink(destination: List {
                            ForEach(bluetoothManager.devicesConnected) { device in
                                Text("\(device.name)")
                            }
                            .listStyle(GroupedListStyle())
                            .navigationBarTitle("connected devices", displayMode: .inline)
                        }) {
                            Text("see connected devices")
                        }
                    }
                }
                Section(header: Text("more.settings")) {
                    NavigationLink(destination: SettingsView()) {
                        Text("settings.link")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("home.title")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showHelpSheet = true
                }) {
                    HStack {
                        Text("settings.help")
                        Image(systemName: "questionmark.circle.fill")
                            .imageScale(.large)
                    }
                }
                .actionSheet(isPresented: $showHelpSheet) {
                    ActionSheet(title: Text("settings.help.sheet.title"), message: Text("settings.help.sheet.message"), buttons: [
                        .default(Text("settings.help.sheet.chat")) {
                            self.storage.registerForCustomerly()
                            if let window = UIApplication.shared.windows.first?.rootViewController {
                                Customerly.sharedInstance.openSupport(from: window)
                            }
                        },
                        .default(Text("settings.help.sheet.tech")) {
                            Instabug.identifyUser(withEmail: self.storage.user.email, name: self.storage.user.name)
                            Instabug.show()
                        },
                        .cancel(Text("settings.help.sheet.abort")),
                    ])
                }
            )
        }
    }
}
