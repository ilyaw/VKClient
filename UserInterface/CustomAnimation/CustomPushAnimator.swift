//
//  CustomPushAnimator.swift
//  UserInterface
//
//  Created by Ilya on 24.03.2021.
//

import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationDuration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else {
            return
        }
        guard let destination = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(destination.view)
        
        destination.view.frame = source.view.frame
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        
        destination.view.frame.origin.x += destination.view.frame.width / 2
        destination.view.frame.origin.y -= destination.view.frame.height / 2
        
        let angleOfRotation = -(CGFloat.pi / 2)
        
        destination.view.transform = CGAffineTransform(rotationAngle: angleOfRotation)
        
        
        // MARK: - Animation
        //
        UIView.animateKeyframes(
            withDuration: self.animationDuration,
            delay: 0,
            options: .calculationModePaced,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.95,
                    animations: {
                        destination.view.transform = CGAffineTransform(rotationAngle: angleOfRotation)
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.95,
                    relativeDuration: 0.05,
                    animations: {
                        destination.view.transform = .identity
                    }
                )
            },
            completion: { finished in
                let successfulExecution = finished && !transitionContext.transitionWasCancelled
                if successfulExecution {
                    source.view.transform = .identity
                }
                transitionContext.completeTransition(successfulExecution)
            })
    }
}
