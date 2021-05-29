//
//  ShadowView.swift
//  UserInterface
//
//  Created by Илья Руденко on 26.02.2021.
//

import UIKit


//View для теней фото и прочего
//@IBDesignable
class ShadowView: UIView {
    
    @IBOutlet weak var avatar: UIImageView!
//    {
//        didSet {
//            avatar.translatesAutoresizingMaskIntoConstraints = false
//        }
//    }
    
//    @IBInspectable
    var cornerRadius: CGFloat = 25 {
        didSet {
           setNeedsDisplay()
        }
    }
//
////   @IBInspectable
//    var shadowColor = UIColor.black {
//        didSet {
////            setNeedsDisplay()
//        }
//    }
//
////    @IBInspectable
//    var shadowOpacity: Float = 0.5 {
//        didSet {
////            setNeedsDisplay()
//        }
//    }
//
////    @IBInspectable
//    var shadowOffset = CGSize(width: 2, height: 1) {
//        didSet {
////            setNeedsDisplay()
//        }
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        let maskLayer = CAShapeLayer()
////
//        let objPath = UIBezierPath()
//        objPath.addArc(withCenter: CGPoint(x: radius+1, y: 25), radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
//        maskLayer.path = objPath.cgPath
////        maskLayer.shadowOpacity = shadowOpacity
////        maskLayer.shadowOffset = shadowOffset
//        self.layer.mask = maskLayer
//
////        let blacLayer = CALayer()
////        blacLayer.backgroundColor = shadowColor.cgColor
////        self.layer.addSublayer(blacLayer)
////        blacLayer.frame = self.bounds
//
//        avatar.layer.masksToBounds = true
//        avatar.layer.cornerRadius = radius
//        avatar.layer.backgroundColor = UIColor.white.cgColor
        //====
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 25
        
        
        
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath

        //create imageView
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = cornerRadius
        //add a border (if required)
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.borderWidth = 0
        //set the image
//        avatavatararavatar.image = UIImage(named: "1")
        
        self.addSubview(avatar)
    }
    
}
