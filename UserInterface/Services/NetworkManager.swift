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
        case getPhotos = "photos.get"
        case getAlbums = "photos.getAlbums"
    }
    
    ///получение фотографий человека
    func getPhotos(ownerId: Int = Session.shared.userId, albumId: Int, rev: TypeRev = .antiСhronological, completion: @escaping ((Result<[PhotoItem]>) -> Void)) {
        guard let token = Session.shared.token else { return }
        
        let url = baseURL + Paths.getPhotos.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "owner_id": ownerId,
            "album_id": albumId,
            "extended": "1",
            "rev": rev.rawValue,
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                if let data = response.data {
                    do {
                        let photos = try JSONDecoder().decode(Photos.self, from: data).response.items
                        completion(.success(photos))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    ///получение списка альбомов по ID юзера
    func getAlbums(userId: Int, completion: @escaping ((Result<[AlbumItem]>) -> Void)) {
        guard let token = Session.shared.token else { return }
        
        let url = baseURL + Paths.getAlbums.rawValue
        
        let parameters: Parameters = [
            "access_token": token,
            "v": versionVKAPI,
            "user_id": userId,
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success( _):
                if let data = response.data {
                    do {
                        let albums = try JSONDecoder().decode(Albums.self, from: data).response.items
                        completion(.success(albums))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

