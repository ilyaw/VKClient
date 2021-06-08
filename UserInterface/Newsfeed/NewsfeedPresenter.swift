//
//  NewsfeedPresenter.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    
    weak var viewController: NewsfeedDisplayLogic?
    
    // layout устройства
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        
        switch response {
        case .presentNewsfeed(let feed, let revealedPostIds):
            
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem,
                              profiles: feed.profiles,
                              groups: feed.groups,
                              revealedPostIds: revealedPostIds)
            }
            
            let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed cells count", comment: ""),
                                                               cells.count)
            
            let feedViewModel = FeedViewModel(cells: cells, footerTitle: footerTitle)
            
            viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        case .presentFooterLoader:
            viewController?.displayData(viewModel: .displayFooterLoader)
        }
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        
        let isFullSizedPost = revealedPostIds.contains(feedItem.postId)
        
        // закэшировать
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text,
                                               photoAttachments: photoAttachments,
                                               isFullSizedPost: isFullSizedPost)
        
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        
        return FeedViewModel.Cell(postId: feedItem.postId,
                                       iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: postText,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       shares: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       photoAttachments: photoAttachments,
                                       sizes: sizes)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        
        var counterString = String(counter)
        
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
         }
        
        return counterString
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourseId = sourceId >= 0 ? sourceId : -sourceId
        
        let profileRepresentable = profilesOrGroups.first { (myProfileRepresentable) -> Bool in
            myProfileRepresentable.id == normalSourseId
        }
        
        return profileRepresentable!
    }
    
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ (attachment) in
            attachment.photo
        }), let firstPhoto = photos.first else { return nil }
        
        return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: firstPhoto.srcBIG,
                                                          width: firstPhoto.width,
                                                          height: firstPhoto.height)
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap { (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: photo.srcBIG,
                                                              width: photo.width,
                                                              height: photo.height)
        }
    }
    
}
