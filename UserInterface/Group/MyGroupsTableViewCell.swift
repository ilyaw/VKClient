//
//  MyGroupsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ group: GroupItem) {
        self.groupName.text = group.name
        
        if let url = URL(string: group.photo50) {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.avatar.sd_setImage(with: url)
                }
            }
        }
    }
    
    
    override func prepareForReuse() {
        self.groupName.text = nil
        self.avatar.image = nil
    }

}
