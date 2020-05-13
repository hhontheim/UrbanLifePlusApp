//
//  DevView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct DevView: View {
    @EnvironmentObject var userData: UserData
    
    @State var userId: String = ""
    @State var identityToken: String = ""
    @State var authorizationCode: String = ""
    
    var body: some View {
        List {
            Section(header: Text("Sign In With Apple Details")) {
                VStack(alignment: .leading) {
                    Text("User ID")
                    TextField("User ID", text: $userId, onEditingChanged: { _ in
                        self.userId = self.userData.userId
                    })
                        .onAppear {
                            self.userId = self.userData.userId
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading) {
                    Text("Identity Token (JWT)")
                    TextField("Identity Token", text: $identityToken, onEditingChanged: { _ in
                        self.identityToken = String(data: self.userData.identityToken, encoding: String.Encoding.utf8) ?? ""
                    })
                        .onAppear {
                            self.identityToken = String(data: self.userData.identityToken, encoding: String.Encoding.utf8) ?? ""
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading) {
                    Text("Authorization Code")
                    TextField("Authorization Code", text: $authorizationCode, onEditingChanged: { _ in
                        self.authorizationCode = String(data: self.userData.authorizationCode, encoding: String.Encoding.utf8) ?? ""
                    })
                        .onAppear {
                            self.authorizationCode = String(data: self.userData.authorizationCode, encoding: String.Encoding.utf8) ?? ""
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
        .listStyle(DefaultListStyle())
        .navigationBarTitle("dev.title")    }
}

