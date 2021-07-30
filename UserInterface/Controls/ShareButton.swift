//
//  ShareButton.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit

class ShareControl: UIControl {

    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let share = UIImage(named: "share")
    private let sharePressed = UIImage(named: "share")
    
    private var flag = false {
        didSet {
            if flag {
                self.actionButton.setImage(sharePressed, for: .normal)
                self.countLabel.textColor = UIColor.black
            } else {
                self.actionButton.setImage(share, for: .normal)
                self.countLabel.textColor = UIColor.black
            }
        }
    }
    
    private var shareCount = 0 {
        didSet {
            countLabel.text = "\(shareCount)"
            flag = !flag
        }
    }
    
    func setShare(count: Int) {
        self.shareCount = count
        flag = false
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
        case false:
            self.shareCount += 1
           
        }
    }

}
