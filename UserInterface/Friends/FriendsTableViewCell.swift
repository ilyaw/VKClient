//
//  FriendsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 14.02.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ user: FriendItem) {
        self.name.text = user.firstName + " " + user.lastName
        if let url = URL(string: user.photo50 ?? "") {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.shadowView.avatar.sd_setImage(with: url)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.shadowView.avatar.image = nil
        self.name.text = nil
    }
}
