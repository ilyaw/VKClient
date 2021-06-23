//
//  NewsfeedCellLayoutCalculator.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//

import Foundation
import UIKit

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }

    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes {
        
        var showMoreTextButton = false
        
        let cardViewWidth = screenWidth - NewsfeedConstants.cardInsets.left - NewsfeedConstants.cardInsets.right
        
        // MARK: Работа с postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: NewsfeedConstants.postLabelInsets.left, y: NewsfeedConstants.postLabelInsets.top),
                                    size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - NewsfeedConstants.postLabelInsets.left - NewsfeedConstants.postLabelInsets.right
            var height = text.height(width: width, font: NewsfeedConstants.postLabelFont)
            
            let limitHeight = NewsfeedConstants.postLabelFont.lineHeight * NewsfeedConstants.minifiedPostLimitLines
            
            if !isFullSizedPost && height > limitHeight {
                height = NewsfeedConstants.postLabelFont.lineHeight * NewsfeedConstants.minifiedPostLines
                showMoreTextButton = true
            }
        
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: Работа с moreTextButtonFrame
        
        var moreTextButtonSize = CGSize.zero
        
        if showMoreTextButton {
            moreTextButtonSize = NewsfeedConstants.moreTextButtonSize
        }
        
        let moreTextButtonOrigin = CGPoint(x: NewsfeedConstants.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        
        // MARK: Работа с attachmentFrame
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? NewsfeedConstants.postLabelInsets.top : moreTextButtonFrame.maxY + NewsfeedConstants.postLabelInsets.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                     size: CGSize.zero)
        
        if let attachment = photoAttachments.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            
            if photoAttachments.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            } else if photoAttachments.count > 1 {
                
                var photos = [CGSize]()
                for photo in photoAttachments {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
                    photos.append(photoSize)
                }
                
                let rowHeight = RowLayout.rowHeightCounter(superViewWidth: cardViewWidth, photosArray: photos)
                attachmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight!)
            }
            
        }
        
        // MARK: Работа с bottomViewFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth, height: NewsfeedConstants.bottomViewHeight))
        
        // MARK: Работа с totalHeight
        
        let totalHeight = bottomViewFrame.maxY + NewsfeedConstants.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     attachmentFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
