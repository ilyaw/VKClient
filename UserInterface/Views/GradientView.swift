//
//  GalleryView.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//

import UIKit

class GradientView: UIView {
    
    private var startColor: UIColor?
    private var endColor: UIColor?
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupGradient()
        startColor = .startGradientNewsfeedGrey
        endColor = .endGradientNewsfeedGrey
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
                return
            }
            
            setupGradientColors()
        }
    }
    
    //если пользуемся через storyboard то юзаем этот инит
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupGradient()
        
        startColor = .startGradientNewsfeedGrey
        endColor = .endGradientNewsfeedGrey
        
        setupGradientColors()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    private func setupGradientColors() {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
        
    }
}
