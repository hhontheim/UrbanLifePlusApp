//
//  ContentView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var storageTemp: StorageTemp
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                CommunicationView()
                SettingsView()
            }
            if !storageTemp.userIsLoggedIn {
                LogInView()
                    .animation(.default)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            #if targetEnvironment(simulator)
            self.storageTemp.userIsLoggedIn = true
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let storageDebugTemp = StorageTemp()
        let storageDebugLocal = StorageLocal()

        return ContentView()
            .environmentObject(storageDebugTemp)
            .environmentObject(storageDebugLocal)
            .onAppear {
                storageDebugTemp.userIsLoggedIn = true
//                storageDebugLocal.userId = "IDIDIDIDID"
//                storageDebugLocal.givenName = "Max"
//                storageDebugLocal.familyName = "Mustermann"
//                storageDebugLocal.email = "mustermann@hontheim.net"
        }
    }
}
