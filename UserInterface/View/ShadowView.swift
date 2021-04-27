//
//  ShadowView.swift
//  UserInterface
//
//  Created by Илья Руденко on 26.02.2021.
//

import UIKit

//@IBDesignable
class ShadowView: UIView {
    
    @IBOutlet weak var avatar: UIImageView!
    
//    @IBInspectable
    var radius: CGFloat = 25 {
        didSet {
//           setNeedsDisplay()
        }
    }
    
//   @IBInspectable
    var shadowColor = UIColor.black {
        didSet {
//            setNeedsDisplay()
        }
    }
    
//    @IBInspectable
    var shadowOpacity: Float = 0.5 {
        didSet {
//            setNeedsDisplay()
        }
    }
    
//    @IBInspectable
    var shadowOffset = CGSize(width: 2, height: 1) {
        didSet {
//            setNeedsDisplay()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation. */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let maskLayer = CAShapeLayer()
        
        let objPath = UIBezierPath()
        objPath.addArc(withCenter: CGPoint(x: radius+1, y: 25), radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
        maskLayer.path = objPath.cgPath
//        maskLayer.shadowOpacity = shadowOpacity
//        maskLayer.shadowOffset = shadowOffset
        self.layer.mask = maskLayer
        
//        let blacLayer = CALayer()
//        blacLayer.backgroundColor = shadowColor.cgColor
//        self.layer.addSublayer(blacLayer)
//        blacLayer.frame = self.bounds
        
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = radius
        avatar.layer.backgroundColor = UIColor.white.cgColor
        self.addSubview(avatar)
    }
    

}
