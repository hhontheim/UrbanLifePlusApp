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
                Toggle(isOn: $userData.toggleMessage) {
                    Text("Toggle me")
                }
                Toggle(isOn: $userData.toggleUserInfo) {
                    Text("Toggle me")
                }
                Button(action: sendMessage) {
                    Text("Send Message")
                }
                Button(action: sendUserInfo) {
                    Text("Send UserInfo")
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
    
    func sendMessage() {
        sendMessage([
            StorageKey.value : userData.value,
            StorageKey.toggleMessage : userData.toggleMessage
        ])
    }
    
    func sendUserInfo() {
        sendUserInfoMessage([
            StorageKey.toggleUserInfo : userData.toggleUserInfo
        ])
    }
}

struct CommunicationView_Previews: PreviewProvider {
    static var previews: some View {
        CommunicationView()
    }
}
