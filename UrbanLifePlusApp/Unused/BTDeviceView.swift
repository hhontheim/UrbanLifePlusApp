//
//  BTDeviceView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct BTDeviceView: View {
//    @EnvironmentObject var bluetoothManager: BluetoothManager
    var device: BluetoothDevice
    
    @State var toggle: Bool = false
    
    var body: some View {
        VStack {
            Text("\(device.name)")
            Button(action: {
                self.toggle.toggle()
                self.device.userLED = self.toggle
            }) {
                Text("Toggle LED")
            }
        }
        .navigationBarTitle(Text(device.name), displayMode: .inline)
        .onAppear {
            self.device.connect()
            self.toggle = false
        }
        .onDisappear {
            self.device.disconnect()
        }
    }
}
