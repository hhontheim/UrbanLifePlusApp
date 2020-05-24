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
                            Image(systemName: "person.crop.square.fill") // profileImage
                                .resizable()
                                .frame(width: 50, height: 50) // 60 x 60
                                .aspectRatio(contentMode: .fill)
                                //                                .clipShape(Circle())
                                .padding(.all, 2)
//                            VStack(alignment: .leading) {
//                                Text("\(storage.user.givenName) \(storage.user.familyName)")
//                                    .font(.headline)
//                                Text(storage.user.email)
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
                            Text("Mein Profil verwalten")
                            .font(.headline)
                        }
                    }
                }
                Section {
                    NavigationLink(destination: DevView()) {
                        ListImageRow(imageName: "hammer", color: .black, text: Text("dev.link"), swapOutlineColorIfDarkMode: true)
                    }
                }
                Section {
                    Button(action: {
                        self.showHelpSheet = true
                    }) {
                        ListImageRow(imageName: "questionmark.circle", color: .green, text: Text("settings.help").foregroundColor(.green))
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
                }
                Section(footer: Text("Version \(version) (Build \(build))")) {
                    Button(action: {
                        self.storage.appState.userIsLoggedIn = false
                        self.storage.persist()
                    }) {
                        ListImageRow(imageName: "lock.open", color: .blue, text: Text("settings.logout")
                        )
                    }
                    Button(action: {
                        self.showNukeSheet = true
                    }) {
                        ListImageRow(imageName: "trash", color: .red, text: Text("settings.nuke")
                            .foregroundColor(.red)
                        )
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
            .navigationBarTitle("settings.title")
        }
        .tabItem {
            Text("settings.tab")
            Image(systemName: "gear")
                .imageScale(.large)
        }
    }
}
