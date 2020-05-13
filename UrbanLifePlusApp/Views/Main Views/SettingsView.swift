//
//  SettingsView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Binding var userIsLoggedIn: Bool
    @EnvironmentObject var userData: UserData
    
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Image("profileImage")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text("\(userData.givenName) \(userData.familyName)")
                                    .font(.headline)
                                Text(userData.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                Section(footer: Text("Version \(version) (Build \(build))")) {
                    NavigationLink(destination: DevView()) {
                        Text("dev.link")
                    }
                    Button(action: {
                        self.userIsLoggedIn = false
                    }) {
                        Text("settings.logout")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("settings.title")
        }
        .tabItem {
            Text("settings.tab")
            Image(systemName: "slider.horizontal.3")
                .imageScale(.large)
        }
    }
}
