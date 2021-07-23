//
//  NetworkManagerOperation.swift
//  UserInterface
//
//  Created by Ilya on 12.05.2021.
//

import Foundation
import Alamofire

class NetworkManagerOperation {
    static let shared = NetworkManagerOperation()

    private init() {}

    private let baseURL = "https://api.vk.com/method/"
    private let versionVKAPI = "5.130"

    private enum Paths: String {
        case getFriends = "friends.get"
    }
   
    //получение списка друзей по ID юзера
    func getFriends(controller: ReloadDataTableController, userId: Int = Session.shared.userId, count: Int = 500, offset: Int = 0, fields: String = "sex, bdate, city, photo_50", completion: (() -> Void)? = nil) {
        guard let token = Session.shared.token else { return }
        
        let url = baseURL + Paths.getFriends.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "user_id": userId,
            "count": count,
            "offset": offset,
            "fields": fields,
        ]
        
        let request = Alamofire.request(url, parameters: parameters)
        let operationQueue = OperationQueue()
        
        let getDataOperation = GetDataOperation(request: request)
        getDataOperation.completionBlock = {
//            print("Ответ от сервера пришел: \(String(describing: getDataOperation.data))")
        }
        
        operationQueue.addOperation(getDataOperation)
        
        let parseFriendsOperation = ParseFriendsOperation()
        parseFriendsOperation.addDependency(getDataOperation)
        parseFriendsOperation.completionBlock = {
//            print("Спарсили: \(parseFriendsOperation.outputData.count) друзей")
        }
        
        operationQueue.addOperation(parseFriendsOperation)
    
        let realmUpdateFriendsOperation = RealmUpdateFriendsOperation()
        realmUpdateFriendsOperation.addDependency(parseFriendsOperation)
        realmUpdateFriendsOperation.completionBlock = {
//            print("Обновили Realm Friends")
        }
        
        OperationQueue.main.addOperation(realmUpdateFriendsOperation)
        
        let reloadFriendsControllerOperation = ReloadFriendsControllerOperation(controller: controller)
        reloadFriendsControllerOperation.addDependency(parseFriendsOperation)
        reloadFriendsControllerOperation.completionBlock = {
//            print("Обновили FriendsTableView")
            completion?()
        }
        
        OperationQueue.main.addOperation(reloadFriendsControllerOperation)
    }
}
