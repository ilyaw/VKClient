//
//  NetworkService.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {

    private let authService = Session.shared
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = "5.130"
        
        let url = self.url(from: path, params: allParams)
        let request = URLRequest(url: url)
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    
    private func createDataTask(from request: URLRequest, completion:  @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = path
        components.queryItems = params.map({ URLQueryItem(name: $0, value: $1) })
        
        return components.url!
    }
}
