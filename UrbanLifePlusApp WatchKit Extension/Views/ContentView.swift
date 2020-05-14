//
//  ContentView.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ContentView: View, SessionCommands {
    
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        ZStack {
            if storage.didReceiveInitialDataFromPhone {
                ScrollView {
                    Text("Name: \"\(storage.user.givenName) \(storage.user.familyName)\"")
                    Text("Value: \"\(storage.settings.value)\"")
                    TextField("Text Feld", text: $storage.settings.value)
                    Toggle(isOn: $storage.settings.toggle) {
                        Text("Toggle me")
                    }
                    .padding()
                    Button(action: {
                        self.requestDataFromPhone()
                    }) {
                        Text("Update")
                    }
                }
                .contextMenu(menuItems: {
                    Button(action: {
                        self.requestDataFromPhone()
                    }, label: {
                        VStack{
                            Image(systemName: "arrow.clockwise")
                                .font(.title)
                            Text("Update")
                        }
                    })
                })
                    .navigationBarTitle("Home")
            } else {
                LaunchView()
            }
        }
        .onAppear {
            self.requestDataFromPhone()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
