// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct UserProfile: Codable {
    let username, userType: String
}

struct Course: Codable {
    let course, proffessorName, fromTime, toTime: String
    let key, isActive: String
}
