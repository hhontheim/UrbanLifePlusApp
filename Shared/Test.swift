//
//  Test.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct Test: View {
    var body: some View {
        VStack {
            Text("test.string")
            Text("\(Date())")
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
