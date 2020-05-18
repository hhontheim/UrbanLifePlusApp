import Foundation

//struct User: Codable {
//    var name: String
//    var age: Int
//    init() {
//        name = "/"
//        age = 0
//    }
//}
//
//enum StorageKey: String, CaseIterable {
//    case a
//    case b
//}
//
//
//let user1: User = User()
//let user2: User = User()
//
//var dataToSend: [String: String] = [:]
//
//let encoder = JSONEncoder()
////encoder.outputFormatting = .withoutEscapingSlashes
//
//if let user1Encoded: Data = try? encoder.encode(user1) {
//    if let asd: String = String(data: user1Encoded, encoding: .utf8) {
//        dataToSend["a"] = asd
//    }
//}
//
//
////if let user2Encoded: Data = try? encoder.encode(user2),
////    let user2JSON: String = String(data: user2Encoded, encoding: .utf8) {
////    dataToSend["b"] = user2JSON
////}
//
////
////let dic = ["key1": "value1", "key2": "value2"]
////let cookieHeader = dic.map { $0.0 + "=" + $0.1 }.joined(separator: ";")
////print(cookieHeader) // key2=value2;key1=value1
//
//
//let finalString: String = dataToSend.description
//
//print(finalString)//.replacingOccurrences(of: "\"", with: "\""))
//
//
//
//let dic = ["2": "B", "1": "A", "3": "C"]
//
//do {
//    let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
//    // here "jsonData" is the dictionary encoded in JSON data
//
//    let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//    // here "decoded" is of type `Any`, decoded from JSON data
//
//    // you can now cast it with the right type
//    if let dictFromJSON = decoded as? [String:String] {
//        // use dictFromJSON
//    }
//} catch {
//    print(error.localizedDescription)
//}



let nameComps  = PersonNameComponentsFormatter().personNameComponents(from: "Max Mustermann")!

let firstLetter = nameComps.givenName!
let lastName = nameComps.familyName!

let sortName = "\(firstLetter). \(lastName)"  // J. Singh

