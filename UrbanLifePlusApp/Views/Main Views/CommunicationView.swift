//
//  Communication.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct CommunicationView: View {
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        NavigationView {
            VStack {
//                TextField("Text Feld", text: $storage.settings.value, onEditingChanged: { stillTyping in
//                    if !stillTyping {
//                        self.storage.persist()
//                    }
//                })
                TextField("Text Feld", text: $storage.user.givenName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    self.storage.persist()
                }) {
                    Text("Persist")
                }
            }
            .navigationBarTitle("communication.title")
        }
        .tabItem {
            Text("communication.tab")
            Image(systemName: "link")
                .imageScale(.large)
        }
    }
}

struct CommunicationView_Previews: PreviewProvider {
    static var previews: some View {
        CommunicationView()
    }
}
