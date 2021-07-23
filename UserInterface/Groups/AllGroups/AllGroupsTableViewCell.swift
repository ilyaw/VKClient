//
//  AllGroupsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit

protocol AllGroupsTableViewCellDelegate: AnyObject {
    func addGroup(for groupId: String?)
}

class AllGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: CircleView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var addGroupButton: UIButton!
    
    private var id: String?
    
    weak var delegate: AllGroupsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ viewModel: GroupViewModel) {
        self.id = viewModel.id
        self.groupNameLabel.text = viewModel.title
        self.setPhoto(url: viewModel.photoURL, imageView: shadowView.avatar)
        
        self.addGroupButton.isHidden = viewModel.isMember
        self.addGroupButton.addTarget(self, action: #selector(didTapAddGroupButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddGroupButton() {
        delegate?.addGroup(for: self.id)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.shadowView.avatar.image = nil
        self.groupNameLabel.text = nil
        
    }
    
    private func setPhoto(url: String, imageView: UIImageView) {
        PhotoService.shared.photo(urlString: url )
            .done { image in imageView.image = image }
            .catch { print($0.localizedDescription) }
    }
}
