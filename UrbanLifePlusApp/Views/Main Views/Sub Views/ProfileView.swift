//
//  ProfileView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        List {
            Section(header: Text("name")) {
                VStack(alignment: .leading) {
                    Text("givenName")
                    TextField("Text Feld", text: $storage.user.givenName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading) {
                    Text("givenName")
                    TextField("Text Feld", text: $storage.user.familyName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            Section {
                VStack(alignment: .leading) {
                    Text("email")
                    TextField("Text Feld", text: $storage.user.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            Section {
                Button(action: {
                    self.storage.persist()
                }) {
                    Text("Persist")
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("profile.title", displayMode: .inline)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(Storage())
    }
}
