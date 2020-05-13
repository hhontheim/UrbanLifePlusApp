//
//  ContentView.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ContentView: View, SessionCommands {
    @State var content: String = ""
    @State var delivered: String = ""

    var body: some View {
//        ZStack {
//            Text("Bitte öffne zuerst die App auf deinem iPhone um dich anmelden...")
//        }
        ScrollView {
            Text("Hallo!")
            Text("Value: \"\(content)\"")
            Button(action: send) {
                Text("communication.send")
            }
            Text(delivered)
            NavigationLink(destination: Text("Hello").navigationBarTitle("Detail")) {
                Text("Click me!")
            }
        }.navigationBarTitle("Home")
    }
    
    func send() {
        print("hi")
        if sendMessage([StorageKey.value : "value"]) {
            delivered = "true"
        } else {
            delivered = "Fail"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
