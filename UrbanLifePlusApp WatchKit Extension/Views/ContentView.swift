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
    
    @State var didReceiveInitialDataFromPhone: Bool = !false // TODO: Change
    
    var body: some View {
        //        ZStack {
        //            Text("Bitte öffne zuerst die App auf deinem iPhone um dich anmelden...")
        //        }
        ZStack {
            if didReceiveInitialDataFromPhone {
                ScrollView {
                    Text("Value: \"\(userData.value)\"")
                    TextField("Text Feld", text: $userData.value)
                    Toggle(isOn: $userData.toggle) {
                        Text("Toggle me")
                    }
                    .padding()
                    Button(action: {
                        self.requestUserDataFromPhone()
                    }) {
                        Text("requestUserDataFromPhone")
                    }
                }
                .onAppear {
                    return
                }
                .navigationBarTitle("Home")
            } else {
                Group {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Bitte öffne zuerst die App auf deinem iPhone um dich anmelden...")
                        Button(action: {}) {
                            Text("Neu laden...")
                        }
                    }
                }
                .navigationBarTitle("UrbanLife+")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
