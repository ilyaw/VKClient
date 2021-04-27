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

}
