//
//  TestViewShadow.swift
//  UserInterface
//
//  Created by Ilya on 29.05.2021.
//

import UIKit

class CustomShadowView: UIView {

    var photoUser: UIImageView = {
        var image = UIImageView()
        return image
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let cornerRadius: CGFloat = self.bounds.height / 2
        
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    
        photoUser = UIImageView(frame: self.bounds)
        
        photoUser.backgroundColor = .white
        //configure the imageView
        photoUser.clipsToBounds = true
        photoUser.layer.cornerRadius = cornerRadius
        //add a border (if required)
        photoUser.layer.borderColor = UIColor.black.cgColor
        photoUser.layer.borderWidth = 0
        
        self.addSubview(photoUser)
    }
    

}
