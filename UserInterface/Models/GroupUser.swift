//
//  GroupUser.swift
//  UserInterface
//
//  Created by Илья Руденко on 06.03.2021.
//

import Foundation

struct GroupUser {
    let titleForHeader: String
    var users: [FriendItem]
    
    mutating func addUser(_ user: FriendItem) {
        users.append(user)
    }
}
