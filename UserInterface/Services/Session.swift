//
//  Session.swift
//  UserInterface
//
//  Created by Илья Руденко on 16.03.2021.
//

import Foundation
import Alamofire

class Session {
    static let shared = Session()
    
    private init() {}
    
    var token: String!
    var userId: Int!
}
