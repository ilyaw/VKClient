//
//  UIAlertController.swift
//  UserInterface
//
//  Created by Ilya on 18.05.2021.
//

import Foundation
import UIKit

extension UIAlertController {
    static func create(_ message: String) -> UIAlertController  {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        return alert
    }
}
