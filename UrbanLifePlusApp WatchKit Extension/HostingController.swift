//
//  HostingController.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<AnyView> {
    
    var userData: UserData!

    override var body: AnyView {
        
        userData = (WKExtension.shared().delegate as! ExtensionDelegate).userData
        
        return AnyView(ContentView().environmentObject(userData))
    }
}
