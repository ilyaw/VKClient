//
//  GroupUser.swift
//  UserInterface
//
//  Created by Илья Руденко on 06.03.2021.
//

import Foundation

//class GroupUser {
//    var firstLetter: String
//    var users: [User]
//    
//    init(firstLetter: String, users: [User]) {
//        self.firstLetter = firstLetter
//        self.users = users
//    }
//}
//
////сортировка по первой букве фамилии в алфавитном порядке
//func groupUsersByFirstLetter() -> [GroupUser] {
//    
//    let friends = getFriends()
//    var groupUsers: [GroupUser] = []
//    
//    let sorted = friends.sorted { $0.lastName.first! < $1.lastName.first! }
//    
//    for user in sorted {
//        let firstLetter = String(user.lastName.first!)
//        
//        if groupUsers.count == 0 {
//            groupUsers.append(GroupUser.init(firstLetter: firstLetter, users: [user]))
//        } else {
//            
//            if firstLetter == groupUsers.last?.firstLetter {
//                groupUsers.last?.users.append(user)
//            } else {
//                groupUsers.append(GroupUser.init(firstLetter: firstLetter, users: [user]))
//            }
//        }
//    }
//    
//    return groupUsers
//}
