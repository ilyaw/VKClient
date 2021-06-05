//
//  User.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
