//
//  BTDeviceView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct BTDeviceView: View {
    var device: BTDevice
    
    @State var blink: Bool = false {
        willSet {
            print(newValue)
        }
    }
    
    var body: some View {
        VStack {
            Text("\(device.name)")
            Toggle(isOn: self.$blink) {
                Text("blink")
            }
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
