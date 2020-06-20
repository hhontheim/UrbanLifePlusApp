//
//  StorageHelper.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 17.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation

#if os(iOS)
extension NSUbiquitousKeyValueStore: StorageHelper {}
#elseif os(watchOS)
extension UserDefaults: StorageHelper {}
#endif

protocol StorageHelper {
    func pull(for key: StorageKey) -> Data?
    func push(_ data: Data, for key: StorageKey)
}

extension StorageHelper {
    func pull(for key: StorageKey) -> Data? {
        Storage.container.data(forKey: key.rawValue)
    }
    
    func push(_ data: Data, for key: StorageKey) {
        Storage.container.set(data, forKey: key.rawValue)
    }
}
