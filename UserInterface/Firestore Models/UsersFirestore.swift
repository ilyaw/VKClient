//
//  FirebaseUsers.swift
//  UserInterface
//
//  Created by Ilya on 23.04.2021.
//

import Foundation
import FirebaseDatabase

class FirebaseUser {
    let id: Int
    let firstName: String
    let lastName: String
    
    
    init(id: Int,
         firstName: String,
         lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init?(dict: [String: Any]) {
        guard
            let id = dict["id"] as? Int,
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String
            else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    convenience init(from user: FriendItem) {
        let id = user.id
        let firstName = user.firstName
        let lastName = user.lastName
        
        self.init(id: id,
                  firstName: firstName,
                  lastName: lastName)
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "id": id,
            "firstName": firstName,
            "lastName": lastName
        ]
    }
 }

