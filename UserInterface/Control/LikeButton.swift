//
//  LikeButton.swift
//  UserInterface
//
//  Created by Илья Руденко on 26.02.2021.
//

import UIKit

//@IBDesignable
class LikeButton: UIControl {
    
    var button = UIButton(type: .custom)
    var label = UILabel()
    
    let imgNoLike = UIImage(named: "like")
    let imgLike = UIImage(named: "like_pressed")
    
    var flag = false
    var likeCount = 0 {
        didSet {
           label.text = "\(likeCount)"
            flag = !flag
        }
    }
    
    func setLike(count: Int) {
        self.likeCount = count
        flag = false
    }
    
    private func setup() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        let whitespace = CGFloat(5)
        let buttonFrame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.height,
            height: self.frame.height
        )
        let labelFrame = CGRect(
            x: buttonFrame.width + whitespace,
            y: 0,
            width: self.frame.width - 2 * (buttonFrame.width + whitespace),
            height: self.frame.height
        )
        
        button.frame = buttonFrame
        button.setImage(imgNoLike, for: .normal)
        button.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        
        label.frame = labelFrame
        label.text = "\(likeCount)"
        
        self.addSubview(label)
        self.addSubview(button)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    @objc func like(_ sender: UIButton) {
        switch flag {
        case true:
            self.likeCount -= 1
            self.button.setImage(self.imgNoLike, for: .normal)
            self.label.textColor = UIColor.black
            animate()
        case false:
            self.likeCount += 1
            self.button.setImage(self.imgLike, for: .normal)
            self.label.textColor = UIColor.red
            animate()
        }
    }
    
    private func animate() {
        UIView.transition(with: self.label, duration: 0.5, options: [.transitionCurlUp, .transitionCurlDown], animations: nil, completion: nil)
        
        UIView.transition(with: self, duration: 0.25, options: [.autoreverse], animations: {
            self.button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        }, completion: {_ in
            self.button.transform = .identity
        })
    }
}
