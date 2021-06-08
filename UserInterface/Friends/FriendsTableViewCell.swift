//
//  FriendsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 14.02.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var photoUser: UIImageView = {
        var image = UIImageView()
        return image
    }()
    
    var myView: CustomShadowView = {
        var view = CustomShadowView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        self.addSubview(myView)
        self.myView.addSubview(photoUser)
        
        self.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    let imageHeight: CGFloat = 50, imageWidth: CGFloat = 50
    let xPosition: CGFloat = 10
    let instets: CGFloat = 15.0
    
    func setup(_ user: FriendItem) {
        self.nameLabel.text = user.firstName + " " + user.lastName
        
        photoUser.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        photoUser.backgroundColor = .white
        //configure the imageView
        photoUser.clipsToBounds = true
        photoUser.layer.cornerRadius = 25
        //add a border (if required)
        photoUser.layer.borderColor = UIColor.black.cgColor
        photoUser.layer.borderWidth = 0
        
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

    func usernameFrame() {
        guard let text = nameLabel.text else {  return }

        let nameLabelSize = getLabelSize(text: text, font: nameLabel.font)
        let nameLabelX = imageWidth + instets * 2
        let nameLabelY = bounds.midY - nameLabelSize.height / 2
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)

        self.nameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
    func photoFrame() {
        if myView.frame == .zero {
            let yPosition = (self.frame.height / 2) - (imageHeight / 2)
            myView.frame = CGRect(x: xPosition, y: yPosition, width: imageWidth, height: imageHeight)
        }
    }

    
    
    //    func photoFrame() {
//        let photoSideLinght: CGFloat = 50
//        let photoSize = CGSize(width: photoSideLinght, height: photoSideLinght)
//        let photoOrigin = CGPoint(x: instets, y: bounds.midY - photoSideLinght / 2 )
//
//        self.photoUser.layer.masksToBounds = true
//        self.photoUser.layer.cornerRadius = 25
//
//        self.photoUser.frame = CGRect(origin: photoOrigin, size: photoSize)
//    }
//
//    private func changeBackground(color: UIColor) {
////        self.name.backgroundColor = color
//    }
//
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if self.isSelected {
//            self.changeBackground(color: .systemGray4)
//        } else {
//            self.changeBackground(color: .white)
//        }
//    }
//

    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        // определяем максимальную ширину текста - это ширина ячейки минус отступы слева и справа
        let maxWidth = bounds.width - instets * 2
        // получаем размеры блока под надпись
        // используем максимальную ширину и максимально возможную высоту
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // получаем прямоугольник под текст в этом блоке и уточняем шрифт
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        // получаем ширину блока, переводим её в Double
        let width = Double(rect.size.width)
        // получаем высоту блока, переводим её в Double
        let height = Double(rect.size.height)
        // получаем размер, при этом округляем значения до большего целого числа
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoUser.image = nil
        self.nameLabel.text = nil
    }
}
