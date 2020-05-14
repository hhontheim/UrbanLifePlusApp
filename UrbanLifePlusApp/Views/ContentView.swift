//
//  ContentView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // TODO: Refactor these States to Storage
    #if !targetEnvironment(simulator)
    @State var userIsLoggedIn: Bool = false
    #else
    @State var userIsLoggedIn: Bool = true
    #endif
    @State var firstTimeSeeingLoginScreenAfterClosingTheApp: Bool = true
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                CommunicationView()
                SettingsView(userIsLoggedIn: $userIsLoggedIn)
            }
            if !userIsLoggedIn {
                LogInView(firstTimeSeeingLoginScreenAfterClosingTheApp: $firstTimeSeeingLoginScreenAfterClosingTheApp, userIsLoggedIn: $userIsLoggedIn)
                    .animation(.default)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
