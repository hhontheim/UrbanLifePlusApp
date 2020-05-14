//
//  Communication.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct CommunicationView: View, SessionCommands {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Value: \"\(userData.value)\"")
                TextField("Text Feld", text: $userData.value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Toggle(isOn: $userData.toggle) {
                    Text("Toggle")
                }
                Button(action: {
                    self.sendAppContext(userData: self.userData)
                }) {
                    Text("Send Message")
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
