//
//  Local.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 17.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation

struct Local: Codable {
    var firstTimeSeeingLoginScreenAfterClosingTheApp: Bool
    
    init() {
        firstTimeSeeingLoginScreenAfterClosingTheApp = true
    }
}
