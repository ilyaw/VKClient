//
//  CommentButton.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit

class CommentButton: UIControl {
    
    var button = UIButton(type: .custom)
    var label = UILabel()
    
    let comments = UIImage(named: "comments")
    let commentsPressed = UIImage(named: "comments")
    
    var flag = false
    var commentCount = 0 {
        didSet {
            label.text = "\(commentCount)"
            flag = !flag
        }
    }
    
    func setComment(count: Int) {
        self.commentCount = count
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
        button.setImage(comments, for: .normal)
        button.addTarget(self, action: #selector(comment(_:)), for: .touchUpInside)
        
        label.frame = labelFrame
        label.text = "\(commentCount)"
        label.backgroundColor = .white
        
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
    
    @objc func comment(_ sender: UIButton) {
        switch flag {
        case true:
            self.commentCount -= 1
            self.button.setImage(comments, for: .normal)
            self.label.textColor = UIColor.black
            
        case false:
            self.commentCount += 1
            self.button.setImage(commentsPressed, for: .normal)
            self.label.textColor = UIColor.black
        }
    }

}
