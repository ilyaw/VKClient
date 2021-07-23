//
//  ShadowView.swift
//  UserInterface
//
//  Created by Илья Руденко on 26.02.2021.
//

import UIKit


//View для теней фото и прочего
//@IBDesignable
class CircleView: UIView {
    
    @IBOutlet weak var avatar: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
        
        self.addSubview(avatar)
    }
}
