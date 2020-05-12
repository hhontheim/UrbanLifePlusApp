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
            }
            if !storageTemp.userIsLoggedIn {
                LogInView()
                    .animation(.default)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
