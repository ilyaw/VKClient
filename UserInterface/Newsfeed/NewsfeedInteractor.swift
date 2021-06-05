//
//  NewsfeedInteractor.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    //здесь будем подготавливать сетевой запрос и передавать его в Presentor
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
        case .getNewsfeed:
            service?.getFeed(completion: { [weak self] (revealPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealdedPostIds: revealPostIds))
            })
        case .revealPostIds(postId: let postId):
            service?.revealPostIds(forPostId: postId, completion: { [weak self] (revealPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealdedPostIds: revealPostIds))
            })
        case .getNextBatch:
            self.presenter?.presentData(response: .presentFooterLoader)
            service?.getNextBatch(completion: { [weak self] (revealPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealdedPostIds: revealPostIds))
            })
        }
        
    }
}
