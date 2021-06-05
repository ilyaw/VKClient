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
    
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        var stackView = UIStackView()
//        stackView.distribution = .fillEqually
//        stackView.spacing = 10
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//
//
////        stackView.translatesAutoresizingMaskIntoConstraints = false
//////        stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//////        stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
//////        stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
////
//        self.addSubview(stackView)
//
//        for i in 0...1 {
//
//            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//
//            view.backgroundColor = .systemGray
//            view.layer.masksToBounds = true
//            view.layer.cornerRadius = 16
//            view.alpha = 1
//
//            stackView.addArrangedSubview(view)
//
//        }
//
//
//
//
//    }
    
}
