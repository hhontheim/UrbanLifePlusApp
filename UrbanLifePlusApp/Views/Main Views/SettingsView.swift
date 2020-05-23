//
//  SettingsView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var storage: Storage
    
    @State var showNukeSheet: Bool = false
    
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: DevView()) {
                    Text("dev.link")
                }
            }
            Section(footer: Text("Version \(version) (Build \(build))")) {
                Button(action: {
                    self.storage.appState.userIsLoggedIn = false
                    self.storage.persist()
                }) {
                    Text("settings.logout")
                }
                Button(action: {
                    self.showNukeSheet = true
                }) {
                    Text("settings.nuke")
                        .foregroundColor(.red)
                }
                .actionSheet(isPresented: $showNukeSheet) {
                    ActionSheet(title: Text("settings.nuke.sheet.title"), message: Text("settings.nuke.sheet.message"), buttons: [
                        .cancel(Text("settings.nuke.sheet.abort")),
                        .destructive(Text("settings.nuke.sheet.nuke")) {
                            self.storage.nuke(shouldGoToSettingsToRevokeSIWA: true)
                            self.storage.appState.userIsLoggedIn = false
                        }
                    ])
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("settings.title", displayMode: .inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        return
                    }) {
                        #if !targetEnvironment(simulator)
                        Text("settings.nuke")
                            .foregroundColor(.red)
                        #else
                        Text("Nuke not available in simulator!")
                            .foregroundColor(.red)
                            .disabled(true)
                        #endif
                    }
                }
            }.listStyle(GroupedListStyle())
        }
    }
}
