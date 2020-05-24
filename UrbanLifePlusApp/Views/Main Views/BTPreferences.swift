//
//  BTPreferences.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 23.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct BTPreferences: View {
    var body: some View {
        NavigationView {
            PreferencesList()
            .listStyle(GroupedListStyle())
            .navigationBarTitle("bt.title")
        }
        .tabItem {
            Text("bt.tab")
            Image(systemName: "heart.fill")
                .imageScale(.large)
        }
    }
}
