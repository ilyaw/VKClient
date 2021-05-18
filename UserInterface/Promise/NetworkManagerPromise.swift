//
//  NetworkManagerPpomise.swift
//  UserInterface
//
//  Created by Ilya on 17.05.2021.
//

import Foundation
import Alamofire
import PromiseKit

class NetworkManagerPromise {
    static let shared = NetworkManagerPromise()
    
    private init() {}
    
    private let baseURL = "https://api.vk.com/method/"
    private let versionVKAPI = "5.130"

    private enum Paths: String {
        case getGroups = "groups.get"
        case searchGroups = "groups.search"
    }
    
    //Получение групп пользователя
    func getGroups(on queue: DispatchQueue = .main, userId: Int = Session.shared.userId, extended: Int = 1, count: Int = 1000, offset: Int = 0) -> Promise<[GroupItem]> {
        guard let token = Session.shared.token else {
            return Promise.init(error: VKError.needValidation(message: "Отсутвует Token"))
        }
        
        let url = baseURL + Paths.getGroups.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "user_id": userId,
            "extended": extended,
            "count": count,
            "offset": offset,
        ]
        
        
        return Alamofire.request(url, parameters: parameters)
            .responseJSON()
            .map(on: queue) { json, response -> [GroupItem] in
                guard let data = response.data else { return [GroupItem]() }
                
                do {
                    let groups = try JSONDecoder().decode(Groups.self, from: data).response.items
                    return groups
                } catch {
                    throw VKError.cannotDeserialize(message: error.localizedDescription)
                }
            }
    }
}