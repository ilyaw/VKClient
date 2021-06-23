//
//  File.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//

import Foundation

protocol DataFetcher {
    func getFeed(nextBathFrom: String?, response: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    private let authService = Session.shared
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getFeed(nextBathFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBathFrom
        params["count"] = "30"
        
        networking.request(path: "/method/newsfeed.get", params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = from,
              let response = try? decoder.decode(type.self, from: data) else { return nil }
        
        return response
    }
}
