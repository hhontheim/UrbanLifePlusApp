//
//  BTView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 19.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct BTView: View {
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        NavigationView {
            VStack {
                Text("bt.greeting")
//                Toggle(isOn: $bluetooth.discoverable) {
//                    Text("bt.discoverable")
//                }
            }
            .navigationBarTitle("bt.title")
        }
        .tabItem {
            Text("bt.tab")
            Image(systemName: "antenna.radiowaves.left.and.right")
                .imageScale(.large)
        }
    }
}
