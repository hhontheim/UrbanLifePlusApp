//
//  ContentView.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        ZStack {
            if storage.appState.userIsRegistered && !storage.appState.shouldGoToSettingsToRevokeSIWA && storage.appState.userIsLoggedIn {
                HomeView()
            } else {
                LogInView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
