//
//  ContentView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        ZStack {
            HomeView()
            if !storage.appState.userIsLoggedIn || storage.appState.shouldGoToSettingsToRevokeSIWA {
                ZStack {
                    if colorScheme == .light {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                    }
                    if !storage.appState.userIsLoggedIn {
                        LogInView()
                    }
                    if storage.appState.shouldGoToSettingsToRevokeSIWA {
                        NukedView()
                    }
                }
            }
        }
        .onAppear() {
            #if targetEnvironment(simulator)
            self.storage.nuke(shouldGoToSettingsToRevokeSIWA: false)
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}

