//
//  NewsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

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
    
}
