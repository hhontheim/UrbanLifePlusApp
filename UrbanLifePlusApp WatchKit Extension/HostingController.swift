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
    
    var storage: Storage!

    override var body: AnyView {
        
        storage = (WKExtension.shared().delegate as! ExtensionDelegate).storage
        
        return AnyView(ContentView().environmentObject(storage))
    }
}
