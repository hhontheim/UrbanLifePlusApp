//
//  LogInView.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 17.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        Group {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                Text("w.login.greeting \(storage.appState.userIsRegistered ? ", \(storage.user.givenName)" : "")")
                Text("w.login.message")
                Spacer()
                Button(action: {
                    self.storage.requestDataFromPhone()
                }) {
                    Text("w.login.reload")
                }
            }
        }
        .onAppear {
            self.storage.requestDataFromPhone()
        }
        .navigationBarTitle("w.login.title")
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
