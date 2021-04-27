//
//  Session.swift
//  UserInterface
//
//  Created by Илья Руденко on 16.03.2021.
//

import Foundation
import Alamofire

class Session {
    static let shared = Session()
    
    private init() {}
    
    var token: String!
    var userId: Int!
}

//extension Session {
//    static let custom: Alamofire.Session = {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 30
//
//        let sessionManager = Alamofire.Session(configuration: configuration)
//        return sessionManager
//
//
////          let delegate = Session.default.delegate
////          let manager = Session.init(configuration: configuration,
////                                     delegate: delegate,
////                                     startRequestsImmediately: true,
////                                     cachedResponseHandler: nil)
//       //   return manager
//    }()
//}
