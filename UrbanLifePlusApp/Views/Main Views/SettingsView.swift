//
//  SettingsView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI
import CustomerlySDK
import Instabug

struct SettingsView: View {
    @EnvironmentObject var storage: Storage
    
    @State var showNukeSheet: Bool = false
    @State var showHelpSheet: Bool = false
    
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Image("profileImage")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text("\(storage.user.givenName) \(storage.user.familyName)")
                                    .font(.headline)
                                Text(storage.user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
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
                    #if !targetEnvironment(simulator)
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
                    #else
                    Button(action: { }) {
                        Text("Nuke not available in simulator!")
                            .foregroundColor(.red)
                            .disabled(true)
                    }
                    .disabled(true)
                    #endif
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("settings.title")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showHelpSheet = true
                }) {
                    HStack {
                        Text("settings.help")
                        Image(systemName: "questionmark.circle.fill")
                            .imageScale(.large)
                    }
                }
                .actionSheet(isPresented: $showHelpSheet) {
                    ActionSheet(title: Text("settings.help.sheet.title"), message: Text("settings.help.sheet.message"), buttons: [
                        .default(Text("settings.help.sheet.chat")) {
                            self.storage.registerForCustomerly()
                            if let window = UIApplication.shared.windows.first?.rootViewController {
                                Customerly.sharedInstance.openSupport(from: window)
                            }
                        },
                        .default(Text("settings.help.sheet.tech")) {
                            Instabug.identifyUser(withEmail: self.storage.user.email, name: self.storage.user.name)
                            Instabug.show()
                        },
                        .cancel(Text("settings.help.sheet.abort")),
                    ])
                }
            )
        }
        .tabItem {
            Text("settings.tab")
            Image(systemName: "slider.horizontal.3")
                .imageScale(.large)
        }
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
