//
//  Friends.swift
//  UserInterface
//
//  Created by Ilya on 26.03.2021.
//

import Foundation
import RealmSwift

// MARK: - Friends
struct Friends: Codable {
    var response: FriendsResponse
}

struct FriendsResponse: Codable {
    let count: Int
    var items: [FriendItem]
}

class FriendItem: Object, Codable {
    @objc dynamic var firstName: String
    @objc dynamic var id: Int
    @objc dynamic var lastName: String
    @objc dynamic var photo: String?
    @objc dynamic var domain: String?
    @objc dynamic var city: City?
    var deactivated: Deactivated?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case photo = "photo_100"
        case domain, city
        case deactivated
    }
    
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? FriendItem {
            return self.firstName == object.firstName
                && self.lastName == object.lastName
                && self.photo == object.photo
                && self.domain == object.domain
        } else {
            return false
        }
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}


class City: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
}

enum Deactivated: String, Codable {
    case banned = "banned"
    case deleted = "deleted"
}

