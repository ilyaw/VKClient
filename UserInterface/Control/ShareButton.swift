//
//  ShareButton.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit

class ShareButton: UIControl {

    var button = UIButton(type: .custom)
    var label = UILabel()
    
    let share = UIImage(named: "share")
    let sharePressed = UIImage(named: "share")
    
    var flag = false
    var shareCount = 0 {
        didSet {
            label.text = "\(shareCount)"
            flag = !flag
        }
    }
    
    func setShare(count: Int) {
        self.shareCount = count
        flag = false
        //print(flag)
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
        button.setImage(share, for: .normal)
        button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        
        label.frame = labelFrame
        label.text = "\(shareCount)"
        
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
    
    @objc func share(_ sender: UIButton) {
        switch flag {
        case true:
            self.shareCount -= 1
            self.button.setImage(share, for: .normal)
            self.label.textColor = UIColor.black
            
        case false:
            self.shareCount += 1
            self.button.setImage(sharePressed, for: .normal)
            self.label.textColor = UIColor.black
        }
    }

}
