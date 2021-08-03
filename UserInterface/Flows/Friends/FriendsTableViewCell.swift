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
        label.backgroundColor = .systemBackground
        return label
    }()
    
    private let photoUser: UIImageView = {
        var image = UIImageView()
        return image
    }()
    
    private(set) var shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private let photoSize = Constants.photoSize
    
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
        
        if let url = user.photo {
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

    
    private func photoFrame() {
        photoUser.frame = CGRect(origin: .zero, size: photoSize)
        photoUser.backgroundColor = .white
        photoUser.clipsToBounds = true
        
        photoUser.layer.cornerRadius = photoSize.height / 2
        photoUser.layer.borderColor = UIColor.white.cgColor
        photoUser.layer.borderWidth = 1
        
        if shadowView.frame == .zero {
            let xPosition: CGFloat = 20
            let yPosition = (self.frame.height / 2) - (photoSize.height / 2)
            
            let origin = CGPoint(x: xPosition, y: yPosition)
            
            shadowView.frame = CGRect(origin: origin, size: photoSize)
        }
    }
    
    private func usernameFrame() {
        guard let text = nameLabel.text else {  return }
        
        let instets: CGFloat = 20.0
        let maxWidth = bounds.width - instets * 2
        
        let nameLabelSize = text.getLabelSize(maxWidth: maxWidth, font: nameLabel.font)
        let nameLabelX = photoSize.width + instets * 2
        let nameLabelY = bounds.midY - nameLabelSize.height / 2
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        
        self.nameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoUser.image = nil
        self.nameLabel.text = nil
    }
}
