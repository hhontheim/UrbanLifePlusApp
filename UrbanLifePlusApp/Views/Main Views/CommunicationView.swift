//
//  Communication.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct CommunicationView: View, SessionCommands {
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Value: \"\(storage.settings.value)\"")
                TextField("Text Feld", text: $storage.settings.value, onEditingChanged: { stillTyping in
                    if !stillTyping {
                        self.storage.persist()
                    }
                })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Toggle(isOn: $storage.settings.toggle) {
                    Text("Toggle")
                }
                Button(action: {
                    self.storage.persist()
                }) {
                    Text("Persist")
                }
                Button(action: {
                    self.storage.nuke()
                }) {
                    Text("Nuke (not sim!)")
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
