//
//  CustomInteractiveTransition.swift
//  UserInterface
//
//  Created by Ilya on 24.03.2021.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    
    var hasStarted = false
    var shouldFinish = false
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
            
        case .changed:
            let translation = recognizer.translation(in: recognizer.view?.superview)
            
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            self.shouldFinish = (progress > 0.33)
            
            self.update(progress)
            
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
            
        case .cancelled:
            self.hasStarted = false
            self.cancel()
            
        default:
            break
        }
    }
}
