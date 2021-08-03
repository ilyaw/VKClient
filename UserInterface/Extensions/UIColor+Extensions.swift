//
//  UIColor+Extensions.swift
//  UserInterface
//
//  Created by Ilya on 22.06.2021.
//

import UIKit

extension UIColor {
    static let brandGrey = UIColor(red: 227.0 / 255.0, green: 229.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    static let newsfeedBlue = UIColor(red: 102.0 / 255.0, green: 159.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
    static let newsfeedPaleRed = UIColor(red: 210.0 / 255.0, green: 79.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    static let newsfeedPaleGrey = UIColor(red: 147.0 / 255.0, green: 158.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0)
    static let footerGrey = UIColor(red: 161.0 / 255.0, green: 165.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0)
    
    
    static let likeCountLabel = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .white
        } else {
            return .black
        }
    }
    
    static let newsfeedDarkGrey = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .white
        } else {
            return getColorRGB(red: 58, green: 59, blue: 60)
        }
    }
    
    
    static let newsfeedCollectionView = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .secondarySystemBackground
        } else {
            return .white
        }
    }
    
    static let newsfeedCardView = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .secondarySystemBackground
        } else {
            return .white
        }
    }
    
    
    static let newsfeedPostText =  UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .secondarySystemBackground
        } else {
            return .white
        }
    }
    
    static let startGradientNewsfeedGrey = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .black
        } else {
            return getColorRGB(red: 229, green: 229, blue: 234)
        }
    }
    
    static let endGradientNewsfeedGrey = UIColor { (trait: UITraitCollection) -> UIColor in
        if trait.userInterfaceStyle == .dark {
            return .black
        } else {
            return getColorRGB(red: 242, green: 242, blue: 247)
        }
    }
    
    static let complementaryColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            let ciColor = CIColor(color: .newsfeedPaleGrey)
            let compRed: CGFloat = 1.0 - ciColor.red
            let compGreen: CGFloat = 1.0 - ciColor.green
            let compBlue: CGFloat = 1.0 - ciColor.blue
            return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
        } else {
            return newsfeedPaleGrey
        }
    }
    
    private static func getColorRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0,
                       green: green / 255.0,
                       blue: blue / 255.0,
                       alpha: 1.0)
    }
    
}

