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
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.postAvatar.image = nil
        self.author.text = nil
        self.date.text = nil
        self.contentText.text = nil
        self.contentImageView.image = nil
        self.views.text = nil
    }
    
}
