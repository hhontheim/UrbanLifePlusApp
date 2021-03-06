//
//  DevView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct DevView: View {
    @EnvironmentObject var storage: Storage
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    @State var userId: String = ""
    @State var identityToken: String = ""
    @State var authorizationCode: String = ""
    
    var body: some View {
        List {
            Section(header: Text("Disconnected BLE devices")) {
                ForEach(bluetoothManager.devicesDisconnected) { device in
                    Text("\(device.name)")
                }
            }
            Section(header: Text("Connected BLE devices")) {
                ForEach(bluetoothManager.devicesConnected) { device in
                    Text("\(device.name)")
                }
            }
            Section(header: Text("Sign In With Apple Details")) {
                VStack(alignment: .leading) {
                    Text("User ID")
                    TextField("User ID", text: $userId, onEditingChanged: { _ in
                        self.userId = self.storage.user.userId
                    })
                        .onAppear {
                            self.userId = self.storage.user.userId
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading) {
                    Text("Identity Token (JWT)")
                    TextField("Identity Token", text: $identityToken, onEditingChanged: { _ in
                        self.identityToken = String(data: self.storage.user.identityToken, encoding: String.Encoding.utf8) ?? ""
                    })
                        .onAppear {
                            self.identityToken = String(data: self.storage.user.identityToken, encoding: String.Encoding.utf8) ?? ""
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading) {
                    Text("Authorization Code")
                    TextField("Authorization Code", text: $authorizationCode, onEditingChanged: { _ in
                        self.authorizationCode = String(data: self.storage.user.authorizationCode, encoding: String.Encoding.utf8) ?? ""
                    })
                        .onAppear {
                            self.authorizationCode = String(data: self.storage.user.authorizationCode, encoding: String.Encoding.utf8) ?? ""
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("dev.title", displayMode: .inline)
    }
}

