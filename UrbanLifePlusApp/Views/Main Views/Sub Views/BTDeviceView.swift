//
//  BTDeviceView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct BTDeviceView: View {
    var device: BluetoothDevice
    
    @State var blink: Bool = false
    
    var body: some View {
        VStack {
            Text("\(device.name)")
            Toggle(isOn: $blink) {
                Text("T")
            }
            Button("Toggle", action: {
                self.blink.toggle()
                self.device.blink = self.blink
            })
        }
        .navigationBarTitle(Text(device.name), displayMode: .inline)
        .onAppear {
            self.device.connect()
        }
        .onDisappear {
            self.device.disconnect()
        }
    }
}
