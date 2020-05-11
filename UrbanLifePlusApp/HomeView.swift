//
//  HomeView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 11.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Binding var loggedIn: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Home Screen")
                Button(action: {
                    self.loggedIn = false
                }) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .imageScale(.large)
                        Text("Logout")
                    }
                }
            }
            .navigationBarTitle("Home")
        }
        .tabItem {
            Text("Home")
            Image(systemName: "house.fill")
                .imageScale(.large)
        }
    }
}
