//
//  NetworkManagerPpomise.swift
//  UserInterface
//
//  Created by Ilya on 17.05.2021.
//

import Foundation
import Alamofire
import PromiseKit

// Пример работы с Promise

class NetworkManagerPromise {
    static let shared = NetworkManagerPromise()
    
    private init() {}
    
    private let baseURL = "https://api.vk.com/method/"
    private let versionVKAPI = "5.130"
    
    private enum Paths: String {
        case getGroups = "groups.get"
        case searchGroups = "groups.search"
        case addGroup = "groups.join"
        case removeGroup = "groups.leave"
    }
    
    //Получение групп пользователя
    func getGroups(on queue: DispatchQueue = .main, userId: Int = Session.shared.userId, extended: Int = 1, count: Int = 200, offset: Int = 0) -> Promise<[GroupItem]> {
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
                guard let data = response.data else {
                    throw VKError.dataIsEmpty(message: "response data is empty")
                }
                
                do {
                    let groups = try JSONDecoder().decode(GroupList.self, from: data).models
                    return groups
                } catch {
                    throw VKError.cannotDeserialize(message: error.localizedDescription)
                }
            }
    }
    
    //Получение групп по поисковому запросу
    func searchGroups(textSearch: String, on queue: DispatchQueue = .main, count: Int = 100, offset: Int = 0) -> Promise<[GroupItem]> {
        guard let token = Session.shared.token else {
            return Promise.init(error: VKError.needValidation(message: "Отсутвует Token"))
        }
        
        let url = baseURL + Paths.searchGroups.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "q": textSearch,
            "count": count,
            "type": "group",
            "offset": offset,
        ]
        
        return Alamofire.request(url, parameters: parameters)
            .responseJSON()
            .map(on: queue) { json, response -> [GroupItem] in
                guard let data = response.data else {
                    throw VKError.dataIsEmpty(message: "response data is empty")
                }
                
                do {
                    let groups = try JSONDecoder().decode(GroupList.self, from: data).models
                    return groups
                } catch {
                    throw VKError.cannotDeserialize(message: error.localizedDescription)
                }
            }
    }
    
    func addGroup(groupId: String, on queue: DispatchQueue = .main) -> Promise<Void> {
        guard let token = Session.shared.token else {
            return Promise.init(error: VKError.needValidation(message: "Отсутвует Token"))
        }
        
        let url = baseURL + Paths.addGroup.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "group_id": groupId,
        ]
        
        return Alamofire.request(url, parameters: parameters)
            .responseJSON()
            .map(on: queue) { json, response -> () in
                guard let data = response.data else {
                    throw VKError.dataIsEmpty(message: "response data is empty")
                }
                
                do {
                    let response = try JSONDecoder().decode(GroupResponse.self, from: data)
                    
                    switch response.response {
                    case 1:
                        return
                    case 103:
                        throw VKError.limitIsexceeded(message: "Превышено ограничение на количество вступлений.")
                    default:
                        return
                    }
                    
                } catch {
                    throw VKError.cannotDeserialize(message: error.localizedDescription)
                }
                
            }
    }
    
    func removeGroup(groupId: String, on queue: DispatchQueue = .main) -> Promise<Void> {
        guard let token = Session.shared.token else {
            return Promise.init(error: VKError.needValidation(message: "Отсутвует Token"))
        }
        
        let url = baseURL + Paths.removeGroup.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "group_id": groupId,
        ]
        
        return Alamofire.request(url, parameters: parameters)
            .responseJSON()
            .map(on: queue) { json, response -> () in
                guard let data = response.data else {
                    throw VKError.dataIsEmpty(message: "response data is empty")
                }
                
                do {
                    let a = try JSONDecoder().decode(GroupResponse.self, from: data)
                    print(a)
                    
                } catch {
                    throw VKError.cannotDeserialize(message: error.localizedDescription)
                }
                
            }
    }
}
