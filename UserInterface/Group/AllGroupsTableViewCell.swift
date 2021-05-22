//
//  AllGroupsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ group: GroupItem) {
        self.groupName.text = group.name
        
        PhotoService.shared.photo(urlString: group.photo50 )
            .done { [weak self] image in self?.shadowView.avatar.image = image }
            .catch { print($0.localizedDescription) }
    }
}
