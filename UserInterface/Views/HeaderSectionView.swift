//
//  HeaderSectionView.swift
//  UserInterface
//
//  Created by Ilya on 02.08.2021.
//

import UIKit

class HeaderSectionView: UIView {
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        
        addSubview(sectionLabel)
        sectionLabel.text = text
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .brandGrey
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = CGRect(origin: CGPoint(x: 20, y: 0),
                              size: bounds.size)
        
        sectionLabel.frame = frame
    }
}
