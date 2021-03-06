//
//  GalleryCollectionVIewCell.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GalleryCollectionVIewCell"
    
    let myImageView: WebImageView = {
       let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.brandGrey
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        contentView
        addSubview(myImageView)
        
        // myImageView constaints
        myImageView.fillSuperview() //заполнить пространство внутри каждой ячейки
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        myImageView.image = nil
    }
    
    func set(imageURL: String?) {
        myImageView.set(imageURL: imageURL)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 10
        
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
