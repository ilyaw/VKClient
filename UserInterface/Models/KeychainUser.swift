//
//  KeychainUser.swift
//  UserInterface
//
//  Created by Ilya on 20.05.2021.
//

import Foundation

struct KeychainUser: Codable {
    let id: Int
    let token: String
    let date: TimeInterval
}
