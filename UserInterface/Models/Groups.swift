//
//  Groups.swift
//  UserInterface
//
//  Created by Ilya on 28.03.2021.
//

import Foundation
import RealmSwift

struct Groups: Codable {
    let response: GroupsResponse
}

struct GroupsResponse: Codable {
    let count: Int
    let items: [GroupItem]
}

class GroupItem: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    //@objc dynamic var isClosed: Int = 0
    var type: TypeGroup
    //@objc dynamic var isAdmin, isMember, isAdvertiser: Int
    @objc dynamic var photo50: String = ""
    @objc dynamic var photo100: String = ""
    @objc dynamic var photo200: String = ""

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        //case isClosed = "is_closed"
        case type
//        case isAdmin = "is_admin"
//        case isMember = "is_member"
//        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? GroupItem {
            
            if self.name != object.name {
                print("\(self.name) \(object.name)")
            }
            
            return self.name == object.name && self.photo50 == object.photo50
        }
        return true
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}

enum TypeGroup: String, Codable {
    case event = "event"
    case group = "group"
    case page = "page"
}
