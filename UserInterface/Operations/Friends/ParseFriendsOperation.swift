//
//  ParseFriendsOperation.swift
//  UserInterface
//
//  Created by Ilya on 11.05.2021.
//

import Foundation

//Парсинг данных
class ParseFriendsOperation: Operation {
    var outputData: [FriendItem] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        
        do {
            var friendsModel = try JSONDecoder().decode(Friends.self, from: data).response.items
            
            //without deleted users
            friendsModel = friendsModel.filter {
                $0.deactivated == nil
            }
            
            outputData = friendsModel
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
