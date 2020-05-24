//
//  ListImage.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 24.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct ListImage: View {
    let imageName: String
    let color: Color
    
    var body: some View {
        Rectangle()
            .frame(width: 35, height: 35)
            .foregroundColor(color)
            .cornerRadius(8)
            .inverseMask(Image(systemName: imageName).resizable().padding(8).scaledToFit())
    }
}

extension View {
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
        self.mask(mask
            .foregroundColor(.black)
            .background(Color.white)
            .compositingGroup()
            .luminanceToAlpha()
        )
    }
}
