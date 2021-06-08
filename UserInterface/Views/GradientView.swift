//
//  GalleryView.swift
//  UserInterface
//
//  Created by Ilya on 05.06.2021.
//

import UIKit

class GradientView: UIView {

    @IBInspectable
    private var startColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    
    @IBInspectable
    private var endColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    //если пользуемся через storyboard то юзаем этот инит
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        
        setupGradientColors()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    private func setupGradientColors() {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
}
