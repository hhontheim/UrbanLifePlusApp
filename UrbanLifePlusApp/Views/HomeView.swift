//
//  HomeView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 11.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var storageTemp: StorageTemp
    @EnvironmentObject var storageLocal: StorageLocal
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hallo \(storageLocal.givenName)!")
                    .font(.headline)
                Text("userId: \"\(storageLocal.userId)\"")
                Text("givenName: \"\(storageLocal.givenName)\"")
                Text("familyName: \"\(storageLocal.familyName)\"")
                Text("email: \"\(storageLocal.email)\"")
                Text("identityToken: \"\(storageLocal.identityToken)\"")
                Text("authorizationCode: \"\(storageLocal.authorizationCode)\"")
                Button(action: {
//                    KeychainItem.deleteUserIdentifierFromKeychain()
                    self.storageTemp.userIsLoggedIn = false
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
