//
//  ContentView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var loggedIn: Bool = false
    
    var body: some View {
        ZStack {
            TabView {
                HomeView(loggedIn: $loggedIn)
            }
            if !loggedIn {
                LogInView(loggedIn: $loggedIn)
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
