//
//  BTSettings.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 23.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct BTSettings: View {
    @EnvironmentObject var storage: Storage

    var body: some View {
        let bUserWantsLEDOn = Binding(
            get: { self.storage.bluetooth.userWantsLEDOn },
            set: {
                self.storage.bluetooth.userWantsLEDOn = $0
                self.storage.persist()
        }
        )
        
        return List {
            Toggle(isOn: bUserWantsLEDOn) {
                Text("userWantsLEDOn")
            }
        }
        .navigationBarTitle("bt.prefs", displayMode: .inline)
    }
}

struct BTSettings_Previews: PreviewProvider {
    static var previews: some View {
        BTSettings()
    }
}
