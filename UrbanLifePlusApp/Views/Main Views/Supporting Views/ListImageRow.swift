//
//  ListImageRow.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 24.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ListImageRow: View {
    let imageName: String
    let color: Color
    let text: Text
    
    var body: some View {
        HStack {
            ListImage(imageName: imageName, color: color)
            text
        }
    }
}
