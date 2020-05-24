//
//  ProfileView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

// TODO: Clone Profile. Save button.

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        UITextField.appearance().clearButtonMode = .whileEditing
        
        return List {
            Section(header: Text("profile.givenName")) {
                TextField("profile.givenName", text: $storage.user.givenName)
                    .textContentType(.givenName)
            }
            Section(header: Text("profile.familyName")) {
                TextField("profile.familyName", text: $storage.user.familyName)
                    .textContentType(.familyName)
            }
            Section(header: Text("profile.email")) {
                TextField("profile.email", text: $storage.user.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("profile.title", displayMode: .inline)
        .onDisappear {
            self.storage.persist()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(Storage())
    }
}
