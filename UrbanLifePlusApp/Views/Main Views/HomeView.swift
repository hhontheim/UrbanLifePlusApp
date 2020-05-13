//
//  HomeView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 11.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            VStack {
                Text("home.greeting \(userData.givenName)")
                    .font(.headline)
            }
            .navigationBarTitle("home.title \(userData.givenName)")
        }
        .tabItem {
            Text("home.tab")
            Image(systemName: "house.fill")
                .imageScale(.large)
        }
    }
}
