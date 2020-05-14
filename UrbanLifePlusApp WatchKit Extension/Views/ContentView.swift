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
        ZStack {
            if userData.didReceiveInitialDataFromPhone {
                ScrollView {
                    Text("Value: \"\(userData.value)\"")
                    TextField("Text Feld", text: $userData.value)
                    Toggle(isOn: $userData.toggle) {
                        Text("Toggle me")
                    }
                    .padding()
                    Button(action: {
                        self.requestAppContextFromPhone()
                    }) {
                        Text("Update")
                    }
                }
                .contextMenu(menuItems: {
                    Button(action: {
                        self.requestAppContextFromPhone()
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
            self.requestAppContextFromPhone()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
