//
//  FriendsTableViewCell.swift
//  UserInterface
//
//  Created by Илья Руденко on 14.02.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var shadowView: ShadowView! {
//        didSet {
//            shadowView.translatesAutoresizingMaskIntoConstraints = false
//        }
//    }
    
    @IBOutlet weak var photoUser: UIImageView! {
        didSet {
            photoUser.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func setup(_ user: FriendItem) {
        self.name.text = user.firstName + " " + user.lastName
        
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
    
    let instets: CGFloat = 10.0
    
    func photoFrame() {
        let photoSideLinght: CGFloat = 50
        let photoSize = CGSize(width: photoSideLinght, height: photoSideLinght)
        let photoOrigin = CGPoint(x: instets, y: bounds.midY - photoSideLinght / 2 )
        
        self.photoUser.layer.masksToBounds = true
        self.photoUser.layer.cornerRadius = 25
        
        self.photoUser.frame = CGRect(origin: photoOrigin, size: photoSize)
    }
    
    private func changeBackground(color: UIColor) {
        self.name.backgroundColor = color
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if self.isSelected {
            self.changeBackground(color: .systemGray4)
        } else {
            self.changeBackground(color: .white)
        }
    }
    
    func usernameFrame() {
        guard let text = name.text else {  return }
        
        let nameLabelSize = getLabelSize(text: text, font: name.font)
        let nameLabelX = photoUser.frame.width + instets * 2
        let nameLabelY = bounds.midY - nameLabelSize.height / 2
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        
        self.name.backgroundColor = .white
        self.name.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    
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
        self.name.text = nil
    }
}
