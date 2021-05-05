//
//  NetworkManager.swift
//  UserInterface
//
//  Created by Ilya on 22.03.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private let baseURL = "https://api.vk.com/method/"
    private let versionVKAPI = "5.130"
    
    private enum Paths: String {
        case getFriends = "friends.get"
        case getPhotos = "photos.get"
        case getGroups = "groups.get"
        case searchGroups = "groups.search"
        case getNewsfeed = "newsfeed.get"
    }
    
    //получение списка друзей по ID юзера
    //photo_200_orig убрать
    func getFriends(userId: Int = Session.shared.userId, count: Int = 5000, offset: Int = 0, fields: String = "sex, bdate, city, photo_50, photo_200_orig", completion: @escaping ((Result<[FriendItem], Error>) -> Void)) {
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
        
        AF.request(url, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                if let data = response.data {
                    do {
                        var friends = try JSONDecoder().decode(Friends.self, from: data).response.items
                        
                        //without deleted users
                        friends = friends.filter {
                            $0.deactivated == nil
                        }
                        
//                        friends = friends.filter({ (friend) -> Bool in
//                            if friend.deactivated == nil {
//                                return true
//                            }
//                            return false
//                        })
//                        
                        
                        
                        completion(.success(friends))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    
    //Получение групп пользователя
    func getGroups(userId: Int = Session.shared.userId, extended: Int = 1, count: Int = 1000, offset: Int = 0, completion: @escaping ((Result<[GroupItem], Error>) -> Void)) {
        guard let token = Session.shared.token else { return }
        
        let url = baseURL + Paths.getGroups.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "user_id": userId,
            "extended": extended,
            "count": count,
            "offset": offset,
        ]
        
        AF.request(url, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                if let data = response.data {
                    do {
                        let groups = try JSONDecoder().decode(Groups.self, from: data).response.items
                        completion(.success(groups))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    
    //получение фотографий человека
    func getPhotos(ownerId: Int = Session.shared.userId, albumId: TypeAlbum, rev: TypeRev = .antiСhronological, count: Int = 1000, offset: Int = 0, completion: @escaping ((Result<[PhotoItem], Error>) -> Void)) {
        guard let token = Session.shared.token else { return }
        
        let url = baseURL + Paths.getPhotos.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "owner_id": ownerId,
            "album_id": albumId.rawValue,
            "rev": rev.rawValue,
            "count": count,
            "offset": offset,
        ]
        
        AF.request(url, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                if let data = response.data {
                    do {
                        let photos = try JSONDecoder().decode(Photos.self, from: data).response.items
                        completion(.success(photos))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    //Получение групп по поисковому запросу
    func searchGroups(textSearch: String, count: Int = 1000, offset: Int = 0, completion: @escaping ((Result<[GroupItem], Error>) -> Void) ) {
        guard let token = Session.shared.token else { return }
        
        let url = baseURL + Paths.searchGroups.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "q": textSearch,
            "count": count,
            "offset": offset,
        ]
        
        AF.request(url, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                if let data = response.data {
                    do {
                        let groups = try JSONDecoder().decode(Groups.self, from: data).response.items
                        completion(.success(groups))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    //Получение новостной ленты
    func getNewsFeed() {
        
    }
}

