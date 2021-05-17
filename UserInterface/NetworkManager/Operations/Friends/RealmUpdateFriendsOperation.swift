//
//  RealmUpdateFriendsOperation.swift
//  UserInterface
//
//  Created by Ilya on 11.05.2021.
//

import Foundation

//Сохранения данных в БД Realm
class RealmUpdateFriendsOperation: Operation {
    
    override func main() {
        guard let parseFriendsOperation = dependencies.first as? ParseFriendsOperation,
              let realm = RealmManager.shared else { return }
        
        do {
            try realm.add(objects: parseFriendsOperation.outputData)
        } catch {
            print(error.localizedDescription)
        }
    }
}
