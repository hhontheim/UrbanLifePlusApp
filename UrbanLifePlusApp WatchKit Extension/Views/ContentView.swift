//
//  ContentView.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ContentView: View, SessionCommands {
    @EnvironmentObject var userData: UserData
    
    
    var body: some View {
        //        ZStack {
        //            Text("Bitte öffne zuerst die App auf deinem iPhone um dich anmelden...")
        //        }
        ScrollView {
            Text("Value: \"\(userData.value)\"")
            TextField("Text Feld", text: $userData.value)
            Toggle(isOn: $userData.toggleMessage) {
                Text("Toggle me")
            }
            .padding()
            Toggle(isOn: $userData.toggleUserInfo) {
                Text("Toggle me")
            }
            .padding()
            Button(action: sendMessage) {
                Text("Send Message")
            }
            Button(action: sendUserInfo) {
                Text("Send UserInfo")
            }
        }
        .onAppear {
            return
        }
        .navigationBarTitle("Home")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
