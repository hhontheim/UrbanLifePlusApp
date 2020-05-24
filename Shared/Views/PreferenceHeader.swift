//
//  PreferenceHeader.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 24.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct PreferenceHeader: View {
    var image: String
    var text: Text
    
    var body: some View {
        HStack {
            Image(systemName: image)
            text
        }
    }
}
