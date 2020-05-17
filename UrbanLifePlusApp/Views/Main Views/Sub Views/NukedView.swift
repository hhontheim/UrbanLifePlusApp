//
//  NukeView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 17.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct NukedView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("login.revokeSIWAInSettings.text")
                    .font(.title)
                    .padding(.bottom, 44)
                NukeInstructionsView()
                Spacer()
                Button(action: {
                    guard let url: URL = URL(string: "App-prefs:") else {
                        return
                    }
                    UIApplication.shared.open(url)
                }) {
                    Text("login.revokeSIWAInSettings.toSettings")
                }
                Spacer()
            }
            .animation(.none)
            .navigationBarTitle("login.revokeSIWAInSettings.title")
        }
    }
}

struct NukedView_Previews: PreviewProvider {
    static var previews: some View {
        NukedView()
    }
}
