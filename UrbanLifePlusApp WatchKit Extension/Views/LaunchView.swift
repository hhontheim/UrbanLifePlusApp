//
//  LaunchView.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 14.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct LaunchView: View, SessionCommands {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        Group {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Spacer()
                Text("launch.greeting \(userData.registered ? ", \(userData.givenName)" : "")")
                Text("launch.message")
                Spacer()
                Button(action: {
                    self.requestAppContextFromPhone()
                }) {
                    Text("Neu laden...")
                }
            }
        }
        .navigationBarTitle("UrbanLife+")
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
