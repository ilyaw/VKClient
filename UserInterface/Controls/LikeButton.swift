//
//  LikeButton.swift
//  UserInterface
//
//  Created by Илья Руденко on 26.02.2021.
//

import UIKit

class LikeControl: UIControl {
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imgNoLike = UIImage(named: "like")
    private let imgLike = UIImage(named: "like_pressed")
    
    private var flag = false {
        didSet {
            if flag {
                self.actionButton.setImage(self.imgLike, for: .normal)
                self.countLabel.textColor = .systemRed
            } else {
                self.actionButton.setImage(self.imgNoLike, for: .normal)
                self.countLabel.textColor = .likeCountLabel
            }
        }
    }
    
    private var likeCount = 0 {
        didSet {
            countLabel.text = "\(likeCount)"
            flag = !flag
        }
    }
    
    func setLikeInfo(count: Int, isLike: Bool) {
        self.likeCount = count
        self.flag = isLike
    }
    
    init(countLikes: String, isLike: Bool) {
        super.init(frame: .zero)
        
        self.countLabel.text = countLikes
        self.actionButton.setImage(UIImage(named: "like"), for: .normal)
        self.setup()
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
    
    @objc func like(_ sender: UIButton) {
        switch flag {
        case true:
            self.likeCount -= 1
        case false:
            self.likeCount += 1
        }
        
        self.animate()
    }
    
    private func animate() {
        UIView.transition(with: self.countLabel, duration: 0.5, options: [.transitionCurlUp, .transitionCurlDown], animations: nil, completion: nil)
        
        UIView.transition(with: self, duration: 0.25, options: [.autoreverse], animations: {
            self.actionButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: {_ in
            self.actionButton.transform = .identity
        })
    }
}

