//
//  GroupsInfo.swift
//  UserInterface
//
//  Created by Ilya on 24.07.2021.
//

import Foundation

//struct GroupInfo {
//    let id: Int
//    let activity: String?
//    let membersCount: Int?
//}

// MARK: - Welcome
struct GroupResponseInfo: Codable {
    let response: [GroupInfo]
}

// MARK: - Response
class GroupInfo: Codable {
    var id: Int
    var membersCount: Int?
    var activity: String?
    
    enum GroupKeys: String, CodingKey {
        case id
        case membersCount = "members_count"
        case activity
    }
    
    required init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: GroupKeys.self)
        
        let id = try response.decode(Int.self, forKey: .id)
        let membersCount = try? response.decode(Int.self, forKey: .membersCount)
        let activity = try? response.decode(String.self, forKey: .activity)
        
        self.id = id
        self.membersCount = membersCount
        self.activity = activity
    }
}


//class GroupInfoList: Decodable {
//    var models: [GroupInfo] = []
//
//    var isMember: Int?
//
//    enum ResponseCodingKeys: String, CodingKey {
//        case response
//    }
//
//    enum GroupKeys: String, CodingKey {
//        case id
//        case membersCount = "members_count"
//        case activity
//    }
//
//    required init(from decoder: Decoder) throws {
//        let response = try decoder.container(keyedBy: ResponseCodingKeys.self)
//
//        var qwe = try response.decode([GroupInfo].self, forKey: .response)
//
//        let count = 2 //response.allKeys.count
//        let itemsCount: Int = count
//
//        for _ in 0..<itemsCount {
//            let groupContainer = try response.nestedContainer(keyedBy: GroupKeys.self, forKey: .response)
//
//            let id = try groupContainer.decode(Int.self, forKey: .id)
//            let activity = try? groupContainer.decode(String.self, forKey: .activity)
//            let membersCount = try? groupContainer.decode(Int.self, forKey: .membersCount)
//
//            let group = GroupInfo(id: id, activity: activity, membersCount: membersCount)
//
//            self.models.append(group)
//        }
//    }
//}
