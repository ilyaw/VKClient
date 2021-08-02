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
    static let reuseId = "AllGroupsTableViewCell"
    
    private(set) var photoView: UIImageView = {
        var image = UIImageView()
        return image
    }()
        
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let shortInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .footerGrey
        return label
    }()
    
    private let addGroupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddGroupButton), for: .touchUpInside)
        return button
    }()
    
    private var groupId: String?
    weak var delegate: AllGroupsTableViewCellDelegate?
    
    private let photoSize = Constants.photoSize
    private let addGroupButtonSize = CGSize(width: 25, height: 25)
    private let instets: CGFloat = 15.0
    private var maxWidthForLabel: CGFloat {
        return bounds.width - (instets * 4) - photoSize.width - addGroupButtonSize.width
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(photoView)
        self.addSubview(groupNameLabel)
        self.addSubview(shortInfoLabel)
        self.contentView.addSubview(addGroupButton)
        addGroupButton.addTarget(self, action: #selector(didTapAddGroupButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
        photoFrame()
        groupNameFrame()
        shortInfoFrame()
        addGroupFrame()
    }
    
    private func photoFrame() {
        photoView.backgroundColor = .white
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = photoSize.width / 2
        
        if photoView.frame == .zero {
            let xPosition: CGFloat = 10
            let yPosition = (self.frame.height / 2) - (photoSize.width / 2)
            
            let origin = CGPoint(x: xPosition, y: yPosition)
            
            photoView.frame = CGRect(origin: origin, size: photoSize)
        }
    }
    
    private func groupNameFrame() {
        let nameLabelSize = CGSize(width: maxWidthForLabel, height: 21.0)
        let nameLabelX = photoSize.width + instets * 2
        let nameLabelY = bounds.midY - 21.0
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        
        self.groupNameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    private func shortInfoFrame() {
        let activityLabelSize = CGSize(width: maxWidthForLabel, height: 21.0)
        let activityLabelX = photoSize.width + instets * 2
        let activityLabelY = groupNameLabel.frame.maxY
        let activityLabelOrigin = CGPoint(x: activityLabelX, y: activityLabelY)
        
        self.shortInfoLabel.frame = CGRect(origin: activityLabelOrigin, size: activityLabelSize)
    }
    
    private func addGroupFrame() {
        let addButtonX = shortInfoLabel.frame.maxX + instets
        let addButtonY = self.bounds.midY - addGroupButtonSize.height / 2
        let addButtonOrigin = CGPoint(x: addButtonX, y: addButtonY)
        
        self.addGroupButton.frame = CGRect(origin: addButtonOrigin, size: addGroupButtonSize)
    }
    

    func setup(_ viewModel: GroupViewModel) {
        self.groupId = viewModel.id
        self.groupNameLabel.text = viewModel.title
        self.shortInfoLabel.text = viewModel.shortInfo
        self.setPhoto(url: viewModel.photoURL, imageView: photoView)
        
        self.addGroupButton.isHidden = viewModel.isMember
    }
    
    @objc private func didTapAddGroupButton() {
        delegate?.addGroup(for: self.groupId)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoView.image = nil
        self.groupNameLabel.text = nil
        self.shortInfoLabel.text = nil
    }
    
    private func setPhoto(url: String, imageView: UIImageView) {
        PhotoService.shared.photo(urlString: url )
            .done { image in imageView.image = image }
            .catch { print($0.localizedDescription) }
    }
}
