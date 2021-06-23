//
//  Loading.swift
//  UserInterface
//
//  Created by Илья Руденко on 15.03.2021.
//

import UIKit

//@IBDesignable
class Loading: UIView {
    
        override func draw(_ rect: CGRect) {
            super.draw(rect)
    
            let distance = 50 //смещение по x
            let count = 3 //количество объектов

            var x = 0
            var delay = 0.0
    
            for _ in 1...count {

                let view = UIView(frame: CGRect(x: x, y: 0, width: 30, height: 30))
                view.backgroundColor = .systemGray
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 16
                view.alpha = 0
    
                UIView.animate(withDuration: 0.5,
                               delay: delay,
                               options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                                view.alpha = 1
                        }, completion: nil)
    
                self.addSubview(view)
                
                x += distance
                delay += 0.16
            }
        }
}
