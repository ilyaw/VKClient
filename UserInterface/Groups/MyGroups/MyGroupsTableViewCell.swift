//
//  MyGroupsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.02.2021.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {
    static let reuseId = "MyGroupsTableViewCell"
    
    private(set) var photoView: UIImageView = {
        var image = UIImageView()
        return image
    }()
        
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .footerGrey
        return label
    }()
    
    private let imageSize = CGSize(width: 50, height: 50)
    private let xPosition: CGFloat = 10
    private let instets: CGFloat = 15.0
    private var maxWidthForLabel: CGFloat {
        return bounds.width - (instets * 3) - imageSize.width
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(photoView)
        self.addSubview(groupNameLabel)
        self.addSubview(activityLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        photoFrame()
        groupNameFrame()
        activityFrame()
    }
    
    private func photoFrame() {
        photoView.backgroundColor = .white
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = imageSize.width / 2
        
        if photoView.frame == .zero {
            let yPosition = (self.frame.height / 2) - (imageSize.width / 2)
            photoView.frame = CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
        }
    }
    
    private func groupNameFrame() {
        let nameLabelSize = CGSize(width: maxWidthForLabel, height: 21.0)
        let nameLabelX = imageSize.width + instets * 2
        let nameLabelY = bounds.midY -  21.0
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        
        self.groupNameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    private func activityFrame() {
        let activityLabelSize = CGSize(width: maxWidthForLabel, height: 21.0)
        let activityLabelX = imageSize.width + instets * 2
        let activityLabelY = groupNameLabel.frame.maxY
        let activityLabelOrigin = CGPoint(x: activityLabelX, y: activityLabelY)
        
        self.activityLabel.frame = CGRect(origin: activityLabelOrigin, size: activityLabelSize)
    }
    
    func setup(_ group: GroupItem) {
        self.groupNameLabel.text = group.name
        self.activityLabel.text = group.activity
        
        PhotoService.shared.photo(urlString: group.photo )
            .done { [weak self] image in self?.photoView.image = image }
            .catch { print($0.localizedDescription) }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoView.image = nil
        self.groupNameLabel.text = nil
        self.activityLabel.text = nil
    }
}
