//
//  CommentButton.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit

class CommentButton: UIControl {
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(comment(_:)), for: .touchUpInside)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let comments = UIImage(named: "comment")
    private let commentsPressed = UIImage(named: "comment")
    
    private var flag = false {
        didSet {
            if flag {
                self.actionButton.setImage(commentsPressed, for: .normal)
            } else {
                self.actionButton.setImage(comments, for: .normal)
            }
        }
    }
    
    private var commentCount = 0 {
        didSet {
            countLabel.text = "\(commentCount)"
            flag = !flag
        }
    }
    
    func setComment(count: Int) {
        self.commentCount = count
        flag = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.addSubview(actionButton)
        self.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalToConstant: 25),
            actionButton.heightAnchor.constraint(equalToConstant: 25),
            actionButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.leftAnchor.constraint(equalTo: actionButton.rightAnchor, constant: 5),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    @objc func comment(_ sender: UIButton) {
        switch flag {
        case true:
            self.commentCount -= 1
        case false:
            self.commentCount += 1
        }
    }
}
