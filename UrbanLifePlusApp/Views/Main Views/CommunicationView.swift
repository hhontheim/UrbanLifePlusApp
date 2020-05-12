//
//  Communication.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct CommunicationView: View {
    @State var content: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hallo!")
                Text("Value: \"\(content)\"")
                Button(action: send) {
                    Text("communication.send")
                }
            }
            .navigationBarTitle("communication.title")
        }
        .tabItem {
            Text("communication.tab")
            Image(systemName: "link")
                .imageScale(.large)
        }
    }
    
    func send() {
        print("Hello")
    }
}

struct CommunicationView_Previews: PreviewProvider {
    static var previews: some View {
        CommunicationView()
    }
}
