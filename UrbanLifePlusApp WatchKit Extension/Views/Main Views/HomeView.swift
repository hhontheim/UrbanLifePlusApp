//
//  HomeView.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 17.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var storage: Storage
    
    var body: some View {
        ScrollView {
            Text("w.home.greeting \(storage.user.givenName)")
        }
        .navigationBarTitle("w.home.title")
        .contextMenu(menuItems: {
            Button(action: {
                self.storage.requestDataFromPhone()
            }, label: {
                VStack{
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                    Text("w.home.update")
                }
            })
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
