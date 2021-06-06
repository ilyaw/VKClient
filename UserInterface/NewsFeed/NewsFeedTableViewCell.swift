//
//  NewsFeedTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit
import Foundation

class NewsFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postAvatar: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var like: LikeButton!
    @IBOutlet weak var comment: CommentButton!
    @IBOutlet weak var share: ShareButton!
    @IBOutlet weak var views: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(newsFeed: NewsFeed) {
        self.author.text = newsFeed.ownerName
        
        PhotoService.shared.photo(urlString: newsFeed.ownerAvatar)
            .done { [weak self] image in self?.postAvatar.image = image }
            .catch { print($0.localizedDescription) }
        
        if let url = URL(string: newsFeed.photoContent ?? "") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if let imageData = try? Data(contentsOf: url) {
                        self.contentImageView.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            self.contentImageView.image = UIImage(named: "noimage")
        }
        
        self.date.text = newsFeed.date
        self.contentText.text = newsFeed.text
        
        self.like.setLike(count: newsFeed.likes?.count ?? 0)
        self.share.setShare(count: newsFeed.reposts?.count ?? 0)
        self.comment.setComment(count: newsFeed.comments?.count ?? 0)
        
        self.views.text = "\(newsFeed.views?.count ?? 0)" 

//        self.contentText.text = newsFeed.text
////        self.author = newsFeed.
//
//        if let firstImage = newsFeed.attachments?.first?.photo {
//            if let url = URL(string: firstImage.sizes?[4].url ?? "") {
//                DispatchQueue.global().async {
//                    DispatchQueue.main.async {
//                        self.contentImageView.sd_setImage(with: url)
//                    }
//                }
//            }
//        } else {
//            //            self.author.text = "asdasdas"
//            //            self.contentImageView.alpha = 0
//        }
//
//        self.views.text = "\(newsFeed.views?.count ?? 0)"
//        self.like.setLike(count: newsFeed.likes?.count ?? 0)
//        self.comment.setComment(count: newsFeed.comments?.count ?? 0)
//        self.share.setShare(count: newsFeed.reposts?.count ?? 0)
        
        
        //        if let url = URL(string: user.photo50 ?? "") {
        //            DispatchQueue.global().async {
        //                DispatchQueue.main.async {
        //                    cell.shadowView.avatar.sd_setImage(with: url)
        //                }
        //            }
        //        }
        
        // self.contentImageView.image = UIImage

        
        //        cell.postAvatar.image = UIImage(named: news.postAvatar)
        //        cell.author.text = news.postAuthor
        //        cell.date.text = news.postDate
        //        cell.contentText.text = news.postContentText
        //        cell.contentImageView.image = UIImage(named: news.postImage)
        //
        //        cell.like.setLike(count: news.likeCount)
        //        cell.comment.setComment(count: news.commentCount)
        //        cell.share.setShare(count: news.shareCount)
        //        cell.views.text = String(news.viewsCount)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.postAvatar.image = nil
        self.author.text = nil
        self.date.text = nil
        self.contentText.text = nil
        self.contentImageView.image = nil
        self.views.text = nil
        
        //        self.like = LikeButton()
        //       self.like.button.setImage("nil", for: .normal)
    }
    
}
