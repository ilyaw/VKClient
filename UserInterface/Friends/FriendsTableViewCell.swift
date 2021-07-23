//
//  FriendsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 14.02.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    static let reuseId = "FriendsTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let photoUser: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private(set) var shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowRadius = 5
        return view
    }()
    
    let imageHeight: CGFloat = 50, imageWidth: CGFloat = 50
    let xPosition: CGFloat = 10
    let instets: CGFloat = 15.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        self.addSubview(shadowView)
        self.shadowView.addSubview(photoUser)
        self.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setup(_ user: FriendItem) {
        self.nameLabel.text = user.firstName + " " + user.lastName
        
        if let url = user.photo50 {
            PhotoService.shared.photo(urlString: url)
                .done { [weak self] image in self?.photoUser.image = image }
                .catch { print($0.localizedDescription) }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoFrame()
        usernameFrame()
    }
    
    private func usernameFrame() {
        guard let text = nameLabel.text else {  return }
        
        let maxWidth = bounds.width - instets * 2
        
        let nameLabelSize = text.getLabelSize(maxWidth: maxWidth, font: nameLabel.font)
        let nameLabelX = imageWidth + instets * 2
        let nameLabelY = bounds.midY - nameLabelSize.height / 2
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        
        self.nameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    private func photoFrame() {
        photoUser.frame = CGRect(x: 0, y: 0, width: imageHeight, height: imageWidth)
        photoUser.backgroundColor = .white
        photoUser.clipsToBounds = true
        photoUser.layer.cornerRadius = photoUser.frame.width / 2
        photoUser.layer.borderColor = UIColor.black.cgColor
        photoUser.layer.borderWidth = 0
        
        if shadowView.frame == .zero {
            let yPosition = (self.frame.height / 2) - (imageHeight / 2)
            shadowView.frame = CGRect(x: xPosition, y: yPosition, width: imageWidth, height: imageHeight)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoUser.image = nil
        self.nameLabel.text = nil
    }
}
