import Foundation

enum StorageKey: String, CaseIterable {
    case value
    case toggle
    case registered
    
    case userId
    case givenName
    case familyName
    case email
    case identityToken
    case authorizationCode
}

StorageKey.value.rawValue
